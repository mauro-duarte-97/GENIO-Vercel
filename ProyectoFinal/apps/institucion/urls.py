from django.urls import path
from apps.institucion.views import InstitucionListView # Imp
from apps.carrera.views import CarreraListView # Imp
from apps.profesor.views import ProfesorListView # Imp


urlpatterns = [
    path("lista/", InstitucionListView.as_view(), name="lista_instituciones"),
    path('<int:institucion_id>/carreras/', CarreraListView.as_view(), name='lista_carreras_instituto'),
    path('<int:institucion_id>/profesores/', ProfesorListView.as_view(), name='lista_profesores_instituto'),
]

