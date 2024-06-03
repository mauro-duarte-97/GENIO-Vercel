from django.contrib import admin
from apps.custom_user.models import CustomUser

@admin.register(CustomUser)
class custom_userAdmin(admin.ModelAdmin):
    list_display = ("nombre","email","descripcion","img_perfil","tipo_usuario",)
