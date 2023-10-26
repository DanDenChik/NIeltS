from django.urls import path
from .views import (
    UserRegistration, 
    WordListCreateView, 
    WordRetrieveUpdateDestroyView, 
    WordRandomView, 
    RandomGapFillQuestionView,
    UserProfileView,
    AddFriendView,
    ListFriendsView,
    ListUsersView,
)
from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns = [
    path('register/', UserRegistration.as_view(), name='register'),
    path('login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('login/refresh/', TokenRefreshView.as_view(), name='token_refresh'),
    path("add_friend/", AddFriendView.as_view(), name="add-friend"),
    path("list_friends/", ListFriendsView.as_view(), name="list_friends"),
    path("list_users/", ListUsersView.as_view(), name="list_users"),
    path("view_profile/<int:user_id>/", UserProfileView.as_view(), name="view-profile"),
    path("view_profile/", UserProfileView.as_view(), name="view-self-profile"),
    path('words/', WordListCreateView.as_view(), name='word-list-create'),
    path('words/<int:pk>/', WordRetrieveUpdateDestroyView.as_view(), name='word-detail'),
    path('words/random/<str:level>/', WordRandomView.as_view(), name='word-random'),
    path('test/gap-fill/', RandomGapFillQuestionView.as_view(), name='gap-fill-question')
]