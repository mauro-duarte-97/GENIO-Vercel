from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from django.db import models

class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('El campo Email es obligatorio')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save()
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)

        return self.create_user(email, password, **extra_fields)

class CustomUser(AbstractBaseUser, PermissionsMixin):
    PROFESOR = 'Profesor'
    ALUMNO = 'Alumno'
    INSTITUCION = 'Institución'
    VISITANTE = 'Visitante'
    
    nombre = models.CharField(max_length=100, blank=True, null=True, default='Anonimo')
    email = models.EmailField(unique=True, default=None)
    descripcion = models.TextField(blank=True, null=True, default=None)
    img_perfil = models.ImageField(upload_to='perfiles/user_uploads/', null=True, blank=True, default='UserProfile.png')
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    institucion = models.CharField(max_length=100, blank=True, null=True, default=None)
    fecha_de_nacimiento = models.DateField(default=None, blank=True, null=True)

    GENERO_CHOICES = (
        ('M', 'Masculino'),
        ('F', 'Femenino'),
        ('O', 'Otro'),
    )
    genero = models.CharField(max_length=1, choices=GENERO_CHOICES, default='O', blank=True, null=True)
    
    TIPO_USUARIO_CHOICES = [
        (ALUMNO, 'Alumno'),
        (INSTITUCION, 'Institución'),
        (PROFESOR, 'Profesor'),
        (VISITANTE, 'Visitante'),
    ]
    tipo_usuario = models.CharField(max_length=20, choices=TIPO_USUARIO_CHOICES, default=ALUMNO, blank=True, null=True)

    REQUIRED_FIELDS = []  # Campos requeridos para el inicio de sesión
    USERNAME_FIELD = 'email'  # Campo que se utiliza como nombre de usuario para el inicio de sesión

    # Campos adicionales PISA EL OBJECT DE DJANGO
    objects = CustomUserManager()
   
    def __str__(self):
        return self.email
