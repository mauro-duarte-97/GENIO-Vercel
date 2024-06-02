from django.db import models

class Institucion(models.Model):
    nombre = models.CharField(default="IFTS", max_length=150, blank=True, null=True)
    direccion = models.CharField(default="Argentina", max_length=250, blank=True, null=True)
    coordenadas = models.CharField(default="-34.603722,-58.381592", max_length=250, blank=True, null=True)
    url = models.CharField(default="", max_length=250, blank=True, null=True)
    usuario = models.ForeignKey('custom_user.CustomUser', on_delete=models.CASCADE, related_name='instituciones_usuario', default=None)
    img_perfil = models.ImageField(upload_to='perfiles/ifts_uploads/', default='perfiles/IFTS/IFTS-Default.png' , blank=True, null=True)
    
    def __str__(self):
        return self.nombre