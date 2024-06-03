from django.db import models

class Cursada(models.Model):
    
    titulo = models.CharField(max_length=50, blank=True, null=True, default=None)
    profesor = models.ForeignKey('profesor.Profesor', on_delete=models.CASCADE, related_name='cursadas_profesor', default=None)
    materia = models.ForeignKey('materia.Materia', on_delete=models.CASCADE, related_name='cursadas_materia', default=None)
    fecha_inicio = models.DateField()
    
    # Otras relaciones y campos según tus necesidades

    def __str__(self):
        return self.titulo
