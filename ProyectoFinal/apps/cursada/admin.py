from django.contrib import admin
from apps.cursada.models import Cursada

@admin.register(Cursada)
class CursadaAdmin(admin.ModelAdmin):
    list_display = ("titulo", "fecha_inicio", "get_id_profesor", "get_id_materia")

    def get_id_profesor(self, obj):
        return obj.profesor.id

    def get_id_materia(self, obj):
        return obj.materia.id

    get_id_profesor.short_description = "ID Profesor"
    get_id_materia.short_description = "ID Materia"
