from django.contrib import admin
from django.contrib.auth.admin import UserAdmin
from .models import User, Word, GapFillQuestion

class UserAdmin(UserAdmin):
    list_display = ('username', 'first_name', 'last_name', 'is_staff', 'number_of_words', 'number_of_tests')
    fieldsets = (
        (None, {'fields': ('username', 'password')}),
        ('Personal Info', {'fields': ('first_name', 'last_name')}),
        ('Stats Info', {'fields': ('number_of_words', 'number_of_tests')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions')}),
        ('Important dates', {'fields': ('last_login', 'date_joined')}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'password1', 'password2', 'first_name', 'last_name'),
        }),
    )

admin.site.register(User, UserAdmin)



class WordAdmin(admin.ModelAdmin):
    list_display = ('word', 'definition', 'example_sentence', 'translation', 'level_of_word')

admin.site.register(Word, WordAdmin)

class GapFillQuestionAdmin(admin.ModelAdmin):
    list_display = ('question', 'option_1', 'option_2', 'option_3', 'option_4', 'correct_option')

admin.site.register(GapFillQuestion, GapFillQuestionAdmin)