# Generated by Django 4.2.6 on 2023-11-12 19:03

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('institucion', '0001_initial'),
    ]

    operations = [
        migrations.AlterField(
            model_name='institucion',
            name='nombre',
            field=models.CharField(blank=True, default='IFTS', max_length=150, null=True),
        ),
        migrations.AlterField(
            model_name='institucion',
            name='ubicacion',
            field=models.CharField(blank=True, default='Argentina', max_length=250, null=True),
        ),
    ]