from django.db import models
from apps.custom_user.models import CustomUser
from django.db import models

class Feedback(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    titulo = models.CharField(max_length=100)
    mensaje = models.TextField()

    def __str__(self):
        return f'Feedback by {self.user.nombre}'



class EmailLog(models.Model):
    user = models.ForeignKey(CustomUser, on_delete=models.CASCADE)
    timestamp = models.DateTimeField(auto_now_add=True)
