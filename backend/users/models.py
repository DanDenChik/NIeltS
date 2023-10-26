from django.db import models
from django.contrib.auth.models import AbstractUser, BaseUserManager
from django.utils.translation import gettext_lazy as _

class UserManager(BaseUserManager):
    use_in_migrations = True

    def _create_user(self, username, password, **extra_fields):
        # Create and save user using password and username
        if not username:
            raise ValueError("The given username number must be set")
        user = self.model(username=username, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, username, password=None, **extra_fields):
        # Create default user with permissions
        extra_fields.setdefault("is_staff", False)
        extra_fields.setdefault("is_superuser", False)
        return self._create_user(username, password, **extra_fields)

    def create_superuser(self, username, password, **extra_fields):  # Create admin
        extra_fields.setdefault("is_staff", True)
        extra_fields.setdefault("is_superuser", True)

        if extra_fields.get("is_staff") is not True:
            raise ValueError("Superuser must have is_staff=True.")
        if extra_fields.get("is_superuser") is not True:
            raise ValueError("Superuser must have is_superuser=True.")

        return self._create_user(username, password, **extra_fields)


class User(AbstractUser):
    USERNAME_FIELD = "username"
    email = None
    REQUIRED_FIELDS = []
    objects = UserManager()
    number_of_words = models.PositiveIntegerField(default=0)
    number_of_tests = models.PositiveIntegerField(default=0)

class Word(models.Model):
    word = models.CharField(max_length=100, unique=True)
    definition = models.TextField()
    synonyms = models.ManyToManyField('self', blank=True)
    example_sentence = models.TextField(blank=True)
    translation = models.CharField(max_length=100, default='')
    level_of_word = models.CharField(max_length=2, default='A1', choices=(
        ('A1', 'A1'),
        ('A2', 'A2'),
        ('B1', 'B1'),
        ('B2', 'B2'),
        ('C1', 'C1'),
        ('C2', 'C2'),
    ))

    def __str__(self):
        return self.word

class GapFillQuestion(models.Model):
    question = models.TextField()
    option_1 = models.CharField(max_length=200)
    option_2 = models.CharField(max_length=200)
    option_3 = models.CharField(max_length=200)
    option_4 = models.CharField(max_length=200)
    correct_option = models.IntegerField(choices=[(1, 'Option 1'), (2, 'Option 2'), (3, 'Option 3'), (4, 'Option 4')])

    def __str__(self):
        return self.question

class Friendship(models.Model):
    user = models.ForeignKey(User, related_name='friendships', on_delete=models.CASCADE)
    friend = models.ForeignKey(User, related_name='friend_requests', on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)