from rest_framework.views import APIView
from rest_framework.exceptions import ValidationError
from rest_framework.response import Response
from rest_framework import status, generics
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated

from .serializers import (
    UserSerializer, 
    WordSerializer, 
    GapFillQuestionSerializer,
    FriendshipSerializer,
    UserProfileSerializer,
)
from .models import Word, GapFillQuestion, Friendship

import random

from django.contrib.auth import get_user_model
from django.db.models import Q
from django.shortcuts import get_object_or_404

class UserRegistration(APIView):
    def post(self, request):
        try:
            serializer = UserSerializer(data=request.data)
            serializer.is_valid(raise_exception=True)
            
            password = serializer.validated_data['password']
            confirm_password = request.data['confirm_password']
            if password != confirm_password:
                return Response({'error': 'Passwords do not match.'}, status=status.HTTP_400_BAD_REQUEST)

            User = get_user_model()
            username = serializer.validated_data['username']
            user, created = User.objects.get_or_create(username=username)

            if not created:
                return Response({'error': 'User already registered.'}, status=status.HTTP_400_BAD_REQUEST)
            
            user.set_password(password)
            user.save()

            return Response(serializer.data, status=status.HTTP_201_CREATED)
        except ValidationError as error:
            return Response({'error': error.detail}, status=status.HTTP_400_BAD_REQUEST)
        except:
            return Response({'error': 'An error occurred.'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

class WordListCreateView(generics.ListCreateAPIView):
    queryset = Word.objects.all()
    serializer_class = WordSerializer

class WordRetrieveUpdateDestroyView(generics.RetrieveUpdateDestroyAPIView):
    queryset = Word.objects.all()
    serializer_class = WordSerializer

class WordRandomView(APIView):
    def get(self, request, level):
        try:
            words = Word.objects.filter(level_of_word=level)
        except ValueError:
            return Response({'error': 'No such level'}, status=status.HTTP_400_BAD_REQUEST)
        
        word = random.choice(words)
        request.user.number_of_words += 1
        request.user.save()
        serializer = WordSerializer(word)
        return Response(serializer.data)

class RandomGapFillQuestionView(generics.RetrieveAPIView):
    serializer_class = GapFillQuestionSerializer

    def get(self, request, *args, **kwargs):
        user = request.user

        user.number_of_tests += 1
        user.save()
        questions = GapFillQuestion.objects.all()

        if questions:
            question = random.choice(questions)
            serializer = self.get_serializer_class()(question)
            return Response(serializer.data)
        else:
            return Response({'message': 'No questions available'}, status=400)

class AddFriendView(generics.CreateAPIView):
    queryset = Friendship.objects.all()
    serializer_class = FriendshipSerializer

    def create(self, request, *args, **kwargs):
        User = get_user_model()
        friend_id = request.data.get("friend_id")
        try:
            friend = User.objects.get(id=friend_id)
        except User.DoesNotExist:
            return Response(
                {"error": "User not found"}, status=status.HTTP_404_NOT_FOUND
            )

        if Friendship.objects.filter(user=request.user, friend=friend).exists():
            return Response(
                {"error": "Already friends"}, status=status.HTTP_400_BAD_REQUEST
            )

        friendship = Friendship.objects.create(user=request.user, friend=friend)
        serializer = FriendshipSerializer(friendship)
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class UserProfileView(generics.RetrieveAPIView):

    def get(self, request, user_id=None):
        User = get_user_model()
        
        if user_id:
            user = get_object_or_404(User, id=user_id)
        else:
            user = request.user
        
        serializer = UserSerializer(user)
        return Response(data=serializer.data, status=status.HTTP_200_OK)

class ListFriendsView(generics.ListAPIView):
    serializer_class = FriendshipSerializer

    def get_queryset(self):
        user = self.request.user
        return Friendship.objects.filter(user=user)


class ListUsersView(generics.ListAPIView):
    serializer_class = UserSerializer

    def get_queryset(self):
        User = get_user_model()
        friends = Friendship.objects.filter(user=self.request.user).values_list(
            "friend", flat=True
        )
        return User.objects.exclude(Q(id=self.request.user.id) | Q(id__in=friends))
