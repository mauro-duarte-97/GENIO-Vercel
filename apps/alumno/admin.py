from django.contrib import admin
from apps.alumno.models import Alumno

@admin.register(Alumno)
class AlumnoAdmin(admin.ModelAdmin):
    list_display = ("nombre", "get_id_carrera", "get_id_usuario")
    search_fields = ("nombre", "fk_id_usuario__username")
    def get_id_carrera(self, obj):
        return obj.fk_id_carrera.id

    def get_id_usuario(self, obj):
        return obj.fk_id_usuario.id

    get_id_carrera.short_description = "ID Carrera"
    get_id_usuario.short_description = "ID Usuario"
