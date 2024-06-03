from django import forms
from .models import Feedback

class FeedbackForm(forms.ModelForm):
    # email = forms.EmailField(widget=forms.EmailInput(attrs={'placeholder': 'Correo electrónico'}))
    # nombre = forms.CharField(widget=forms.TextInput(attrs={'placeholder': 'Nombre del usuario'}))

    def __init__(self, *args, **kwargs):
        user = kwargs.pop('user', None)
        super().__init__(*args, **kwargs)
        # if user:
        #     self.fields['email'].initial = user.email
        #     self.fields['nombre'].initial = user.nombre

    class Meta:
        model = Feedback
        fields = ['titulo', 'mensaje']
        widgets = {
            'titulo': forms.TextInput(attrs={'placeholder': 'Título'}),
            'mensaje': forms.Textarea(attrs={'placeholder': 'Mensaje'}),
        }