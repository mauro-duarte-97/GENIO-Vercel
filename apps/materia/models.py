from django.db import models

class Materia(models.Model):
    nombre = models.CharField(max_length=150, blank=True, null=True, default=None)
    carrera = models.ForeignKey('carrera.Carrera', on_delete=models.CASCADE, related_name='materia_carrera', default=None)
    profesor = models.ForeignKey('profesor.Profesor', on_delete=models.CASCADE, related_name='materia_profesor', null=True, default=None)
    
    def __str__(self):
        return self.nombre


class VotacionMateria(models.Model):
    materia = models.ForeignKey(Materia, on_delete=models.CASCADE, related_name='votaciones', default=None)
    usuario = models.ForeignKey('custom_user.CustomUser', on_delete=models.CASCADE, related_name='votaciones_mat_user', default=None)
    valor = models.IntegerField(default=None)

    @property
    def dificultad(self):
        votaciones = VotacionMateria.objects.all()
        if votaciones:
            return sum(voto.valor for voto in votaciones) / len(votaciones)
        else:
            return None