from django.views.generic import ListView
from django.views.generic import DetailView
from .models import Carrera


class CarreraListView(ListView):
    model = Carrera
    template_name = "lista_carrera.html"
    context_object_name = "carreras"

    # Sobreescribimos el método get_queryset para filtrar las carreras por instituto
    def get_queryset(self):
        institucion_id = self.kwargs.get('institucion_id')
        if institucion_id:
            return Carrera.objects.filter(institucion_id=institucion_id)
        return Carrera.objects.all()
        

class CarreraDetailView(DetailView):
    model = Carrera
    template_name = 'detalle_carrera.html'  # Nombre del template
    context_object_name = 'carrera'  # Nombre del objeto en el contexto

