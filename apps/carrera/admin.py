from django.contrib import admin
from apps.carrera.models import Carrera

@admin.register(Carrera)
class carreraAdmin(admin.ModelAdmin):
    list_display = ("nombre","duracion", "get_id_institucion",)

    def get_id_institucion(self, obj):
        return obj.institucion.id

    def dificultad(self, obj):
        votaciones = obj.votaciones.all()
        if votaciones:
            return sum(voto.valor for voto in votaciones) / len(votaciones)

    ID_INSTITUCION = get_id_institucion