# Generated by Django 4.2.6 on 2023-11-10 22:29

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('cursada', '0002_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='cursada',
            name='titulo',
            field=models.CharField(blank=True, default=None, max_length=50, null=True),
        ),
    ]