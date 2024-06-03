from django.contrib import admin
from apps.profesor.models import Profesor

@admin.register(Profesor)
class ProfesorAdmin(admin.ModelAdmin):
    list_display = ("nombre", "get_usuario_id", "get_instituciones_ids", "get_carreras_ids", "img_perfil")

    def get_usuario_id(self, obj):
        return obj.usuario.id
    
    def get_instituciones_ids(self, obj):
        return ", ".join(str(institucion.id) for institucion in obj.institucion.all())

    def get_carreras_ids(self, obj):
        return ", ".join(str(carrera.id) for carrera in obj.carrera.all())

    get_usuario_id.short_description = "ID Usuario"
    get_instituciones_ids.short_description = "ID Institucion"
    get_carreras_ids.short_description = "ID Carrera"
    

