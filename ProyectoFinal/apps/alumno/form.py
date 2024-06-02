from django import forms
from .models import Alumno
from django.contrib.admin.widgets import FilteredSelectMultiple

class AlumnoForm(forms.ModelForm):
    class Meta:
        model = Alumno
        fields = ['nombre', 'fk_id_carrera']
        widgets = {
            'fk_id_carrera': FilteredSelectMultiple("fk_id_carrera", is_stacked=False),
            'nombre': FilteredSelectMultiple("nombre", is_stacked=False, attrs={'name': 'mi_nombre_CustomUser'}),
        }