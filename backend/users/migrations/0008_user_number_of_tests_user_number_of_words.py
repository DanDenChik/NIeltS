# Generated by Django 4.2.4 on 2023-10-16 18:46

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0007_friendship'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='number_of_tests',
            field=models.PositiveIntegerField(default=0),
        ),
        migrations.AddField(
            model_name='user',
            name='number_of_words',
            field=models.PositiveIntegerField(default=0),
        ),
    ]
