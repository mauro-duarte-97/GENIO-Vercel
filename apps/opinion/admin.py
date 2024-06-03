from django.contrib import admin
from apps.opinion.models import Opinion

@admin.register(Opinion)
class OpinionAdmin(admin.ModelAdmin):
    list_display = ("titulo", "contenido", "get_autor",  "get_calificacion", "fecha")

    def get_autor(self, obj):
        return obj.autor.nombre if obj.autor.nombre else None
    
    def get_calificacion(self, obj):
        return obj.calificacion.valor if obj.calificacion.valor else None

    get_autor.short_description = "Name Usuario"



