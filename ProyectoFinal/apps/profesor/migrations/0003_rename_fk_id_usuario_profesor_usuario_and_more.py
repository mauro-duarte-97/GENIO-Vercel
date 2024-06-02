# Generated by Django 4.2.6 on 2024-05-01 22:51

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('materia', '0003_alter_materia_nombre'),
        ('profesor', '0002_profesor_id_institucion'),
    ]

    operations = [
        migrations.RenameField(
            model_name='profesor',
            old_name='fk_id_usuario',
            new_name='usuario',
        ),
        migrations.RemoveField(
            model_name='profesor',
            name='id_institucion',
        ),
        migrations.AddField(
            model_name='profesor',
            name='materia',
            field=models.ForeignKey(default=1, on_delete=django.db.models.deletion.CASCADE, to='materia.materia'),
        ),
    ]
