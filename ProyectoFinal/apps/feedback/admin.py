from django.contrib import admin
from .models import Feedback

@admin.register(Feedback)
class FeedbackAdmin(admin.ModelAdmin):
    list_display = ("get_autor_name", "get_autor_email", "titulo", "mensaje",)

    def get_autor_name(self, obj):
        return obj.user.nombre

    def get_autor_email(self, obj):
        return obj.user.email if obj.user.email else None

    get_autor_name.short_description = "Name Usuario"
    get_autor_email.short_description = "Email Usuario"



