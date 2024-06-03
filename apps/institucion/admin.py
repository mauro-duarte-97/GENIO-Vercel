from django.contrib import admin
from apps.institucion.models import Institucion

@admin.register(Institucion)
class InstitucionAdmin(admin.ModelAdmin):
    list_display = ("nombre", "direccion", "coordenadas", "get_id_usuario")

    def get_id_usuario(self, obj):
        return obj.usuario.id

    get_id_usuario.short_description = "ID Usuario"
