# Generated by Django 4.2.6 on 2024-05-02 01:04

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('cursada', '0003_cursada_titulo'),
    ]

    operations = [
        migrations.RenameField(
            model_name='cursada',
            old_name='fk_id_materia',
            new_name='materia',
        ),
        migrations.RenameField(
            model_name='cursada',
            old_name='fk_id_profesor',
            new_name='profesor',
        ),
    ]
