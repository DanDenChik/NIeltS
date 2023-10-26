from rest_framework import serializers
from .models import User, Word, GapFillQuestion, Friendship
from django.utils.translation import gettext_lazy as _

class UserSerializer(serializers.ModelSerializer):
    password = serializers.CharField(
        label=_("Password"),
        style={'input_type': 'password'},
        trim_whitespace=False,
        max_length=128,
        write_only=True
    )
    confirm_password = serializers.CharField(
        label=_("Confirm Password"),
        style={'input_type': 'password'},
        trim_whitespace=False,
        max_length=128,
        write_only=True
    )

    class Meta:
        model = User
        fields = ('id', 'username', 'password', 'confirm_password', 'first_name', 'last_name', 'number_of_words', 'number_of_tests')
        extra_kwargs = {'password': {'write_only': True}}

class WordSerializer(serializers.ModelSerializer):
    synonyms = serializers.SlugRelatedField(
        many=True,
        queryset=Word.objects.all(),
        slug_field='word',
        required=False
    )
    
    class Meta:
        model = Word
        fields = '__all__'

class GapFillQuestionSerializer(serializers.ModelSerializer):
    class Meta:
        model = GapFillQuestion
        fields = '__all__'

class FriendshipSerializer(serializers.ModelSerializer):
    friend = UserSerializer()

    class Meta:
        model = Friendship
        fields = ('id', 'user', 'friend', 'created_at')

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'username', 'first_name', 'last_name') 