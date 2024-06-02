from django.db import models

class Carrera(models.Model):
    nombre = models.CharField(default="Técnico Superior", max_length=150, blank=True, null=True)
    duracion = models.PositiveIntegerField(default=None)
    institucion = models.ForeignKey('institucion.Institucion', on_delete=models.CASCADE, related_name='carreras_institucion', default=None)
    img_perfil = models.ImageField(upload_to='carrera_uploads/', default='Carreras/Carreras-Perfil.jpeg' , blank=True, null=True)

    def __str__(self):
        return self.nombre
    

class VotacionCarrera(models.Model):
    carrera = models.ForeignKey(Carrera, on_delete=models.CASCADE, default=None)
    usuario = models.ForeignKey('custom_user.CustomUser', on_delete=models.CASCADE, related_name='votaciones', default=None)
    valor = models.IntegerField(default=None)

    @property
    def dificultad(self):
        votaciones = VotacionCarrera.objects.all()
        if votaciones:
            return sum(voto.valor for voto in votaciones) / len(votaciones)
        else:
            return None
