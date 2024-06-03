from django.views.generic.base import TemplateView
from django.views.generic.edit import UpdateView, DeleteView
from django.shortcuts import redirect, render
from django.urls import reverse_lazy
from django.contrib import messages
from django.contrib.auth.mixins import LoginRequiredMixin
from apps.institucion.models import Institucion
from apps.profesor.models import Profesor
from apps.opinion.models import Opinion
from apps.carrera.models import Carrera
from apps.materia.models import Materia
from .forms import CustomUserDeleteForm, CustomUserUpdateForm, SearchForm
from .models import CustomUser
from django.conf import settings



class UserHomeView(LoginRequiredMixin, TemplateView):
    template_name = "userHome.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        context['opiniones'] = Opinion.objects.order_by('-fecha')[:5]  # Obtener las últimas 5 opiniones
        context['google_maps_api_key'] = settings.GOOGLE_API_KEY_1  # Añadir la clave API al contexto
        context['instituciones'] = Institucion.objects.all()
        return context
    
class CustomProfileView(LoginRequiredMixin, TemplateView):
    model = CustomUser 
    template_name = 'perfil.html'  # Nombre del template
    context_object_name = 'usuario'  # Nombre del objeto en el contexto

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user_id = self.kwargs.get('pk')
        user = CustomUser.objects.get(pk=user_id)
        context['usuario'] = user
        return context

class EditarUsuarioView(LoginRequiredMixin, UpdateView):
    model = CustomUser
    form_class = CustomUserUpdateForm
    template_name = 'editar_usuario.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        user_id = self.kwargs.get('pk')
        user = CustomUser.objects.get(pk=user_id)
        context['usuario'] = user
        return context
    
    def form_valid(self, form):
        # Procesar el formulario si es válido
        user = form.save(commit=False)
        user.save()
        # Agregar mensaje de éxito a la lista de mensajes
        messages.success(self.request, 'Usuario actualizado correctamente')
        return super().form_valid(form)

    def form_invalid(self, form):
        # Agregar mensajes de error a la lista de mensajes
        for field, errors in form.errors.items():
            for error in errors:
                messages.error(self.request, f"{field}: {error}")
        return super().form_invalid(form)
    
    def get_success_url(self):
        # Obtener el ID del usuario que se ha actualizado
        user_id = self.object.pk
        # Construir la URL del perfil del usuario usando reverse_lazy
        return reverse_lazy('perfil_usuario', kwargs={'pk': user_id})
    
class EliminarUsuarioView(LoginRequiredMixin, DeleteView):
    model = CustomUser
    form_class = CustomUserDeleteForm
    template_name = 'eliminar_usuario.html'
    success_url = '/'

class SearchView(TemplateView):
    template_name = 'resultado_busqueda.html'

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        form = SearchForm(self.request.GET or None)
        query = None
        results = {
            'institutos': [],
            'carreras': [],
            'materias': [],
            'profesores': []
        }

        if 'query' in self.request.GET:
            if form.is_valid():
                query = form.cleaned_data['query']
                results['institutos'] = Institucion.objects.filter(nombre__icontains=query)
                results['carreras'] = Carrera.objects.filter(nombre__icontains=query)
                results['materias'] = Materia.objects.filter(nombre__icontains=query)
                results['profesores'] = Profesor.objects.filter(nombre__icontains=query)

        context['form'] = form
        context['query'] = query
        context['results'] = results
        return context



