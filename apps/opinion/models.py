from django.core.validators import MaxValueValidator, MinValueValidator
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from django.db import models

# Esta estructura te brinda la flexibilidad de registrar opiniones sobre varias entidades y vincularlas a usuarios.


class Opinion(models.Model):
    titulo = models.CharField(max_length=200, default=None)
    contenido = models.TextField(default=None)  # Comentario de la opinión
    autor = models.ForeignKey('custom_user.CustomUser', on_delete=models.CASCADE, related_name='opiniones_usuario', default=None)  # Usuario que realizó la opinión
    fecha = models.DateTimeField(auto_now_add=True)  # Fecha de la opinión
    calificacion = models.PositiveIntegerField(
        default=5,
        validators=[
            MinValueValidator(1),
            MaxValueValidator(5)
        ],
        help_text="Puntuación de 1 a 5 estrellas"
    )
    # Campos para la relación genérica
    content_type = models.ForeignKey(ContentType, on_delete=models.CASCADE, null=True)
    object_id = models.PositiveIntegerField(null=True)
    content_object = GenericForeignKey('content_type', 'object_id')

    def __str__(self):
        return f'Opinión de {self.autor}'


    def crear_opinion(self):
        # Este método es un poco redundante en Django, porque crear una instancia ya es "crear"
        self.save()

    def eliminar_opinion(self):
        # Este método ayudaría a eliminar la instancia del modelo de la base de datos
        self.delete()






    

    

   





