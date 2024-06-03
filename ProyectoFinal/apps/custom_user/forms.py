from django import forms
from .models import CustomUser
from django.shortcuts import render, redirect


class CustomUserForm(forms.ModelForm):
    class Meta:
        model = CustomUser
        fields = ['email', 'password']
        widgets = {
            'email': forms.TextInput(attrs={'placeholder': 'Correo electrónico'}),
            'password': forms.EmailInput(attrs={'placeholder': 'Contraseña'}),
        }
    
class CustomUserUpdateForm(forms.ModelForm):
    class Meta:
        model = CustomUser
        fields = ['nombre', 'img_perfil']
        widgets = {
            'nombre': forms.TextInput(attrs={'placeholder': 'Nombre del alumno'}),
            'img_perfil': forms.FileInput()
        }

class CustomUserDeleteForm(forms.ModelForm):
    class Meta:
        model = CustomUser
        fields = []  # No necesitas campos, ya que es un formulario para eliminar

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields['confirmacion'] = forms.BooleanField(
            required=True,
            label='Confirmar eliminación',
            help_text='Marca esta casilla para confirmar que deseas eliminar este usuario.',
        )

class SearchForm(forms.Form):
    query = forms.CharField(label='Buscar', max_length=100)
