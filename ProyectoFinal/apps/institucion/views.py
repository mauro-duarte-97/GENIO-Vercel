from django.shortcuts import render
from django.views.generic import ListView
from django.views.generic import DetailView
from .models import Institucion
from django.core.paginator import Paginator
from django.contrib.auth.mixins import LoginRequiredMixin


class InstitucionListView(ListView, LoginRequiredMixin):
    model = Institucion
    template_name = "lista_institucion.html"
    context_object_name = "instituciones"
    #paginate_by = 8

    def get_queryset(self):
        institucion_id = self.kwargs.get('institucion_id')
        if institucion_id:
            return Institucion.objects.filter(institucion_id=institucion_id)
        return Institucion.objects.all()

class InstitucionDetailView(DetailView):
    model = Institucion
    template_name = 'detalle_institucion.html'  # Nombre del template
    context_object_name = 'institucion'  # Nombre del objeto en el contexto

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['institucion_ubicacion'] = self.object.ubicacion
        return context
 