from django.contrib.auth.views import LoginView, LogoutView
from django.contrib.auth.models import User
from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm
from django import forms
from apps.custom_user.models import CustomUser 


# Login
class CustomLoginView(LoginView):
    class Meta:
        model = CustomUser
        fields = ["email", "password"]
        widgets = {
            "email": forms.EmailInput(attrs={"placeholder": "Correo electrónico"}),
            "password": forms.PasswordInput(attrs={"placeholder": "Contraseña"}),
        }

# Logout con boton confirmar:
class CustomLogoutView(LogoutView):
    pass

class LogoutConfirmationView(LogoutView):
    template_name = "index.html"

    def get(self, request, *args, **kwargs):
        return render(request, self.template_name)

# REGISTER   
class RegistrationForm(UserCreationForm):
    email = forms.EmailField(
        max_length=254, help_text="Required. Inform a valid email address."
    )

    class Meta:
        model = CustomUser
        fields = ("email", "password1", "password2")


# class CustomUserCreateForm(forms.ModelForm):
    # class Meta:
    #     model = CustomUser
    #     fields = ['nombre', 'email', 'password', 'tipo_usuario']
    #     widgets = {
    #         'nombre': forms.TextInput(attrs={'placeholder': 'Nombre del alumno'}),
    #         'email': forms.EmailInput(attrs={'placeholder': 'Correo electrónico'}),
    #         'tipo_usuario': forms.Select(attrs={'placeholder': 'Tipo de usuario'}),
    #     }