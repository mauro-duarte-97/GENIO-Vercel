from django.db import models

class Profesor(models.Model):
    nombre = models.CharField(max_length=100, blank=True, null=True, default=None)
    usuario = models.ForeignKey('custom_user.CustomUser', on_delete=models.CASCADE, default=None)  # Usuario del profesor
    institucion = models.ManyToManyField('institucion.Institucion', related_name='profesor_instituciones')  # Muchas instituciones tienen muchos profesores
    carrera = models.ManyToManyField('carrera.Carrera', related_name='profesores_carrera')  # Muchas carreras  tienen muchos profesores
    img_perfil = models.ImageField(upload_to='perfiles/profesores_uploads/', blank=True, null=True, default='Profesores/ProfesorDefault.jpeg')

    def __str__(self):
        return self.nombre