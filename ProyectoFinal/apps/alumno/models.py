from django.db import models

class Alumno(models.Model):
    nombre = models.CharField(max_length=100, blank=True, null=True, default=None)
    fk_id_carrera = models.ForeignKey('carrera.Carrera', on_delete=models.CASCADE, null=True, default=None)
    fk_id_usuario = models.ForeignKey('custom_user.CustomUser', on_delete=models.CASCADE, null=True, default=None)
    # Otras relaciones y campos según tus necesidades

    def __str__(self):
        return self.nombre
