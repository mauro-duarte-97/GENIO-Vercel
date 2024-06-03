from django.contrib import admin
from apps.materia.models import Materia

@admin.register(Materia)
class MateriaAdmin(admin.ModelAdmin):
    list_display = ("nombre", "get_id_carrera", "get_id_profesor",  "dificultad")

    def get_id_carrera(self, obj):
        return obj.carrera.id if obj.carrera else None
    
    def get_id_profesor(self, obj):
        return obj.profesor.id if obj.profesor else None

    def dificultad(self, obj):
        votaciones = obj.votaciones.all()
        if votaciones:
            return sum(voto.valor for voto in votaciones) / len(votaciones)

    get_id_carrera.short_description = "ID Carrera"
    get_id_profesor.short_description = "ID Profesor"
    dificultad.short_description = "Dificultad"
