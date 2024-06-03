from django.urls import path
from apps.cursada.views import CursadaTemplateView


urlpatterns = [
    path("", CursadaTemplateView.as_view(), name="cursada")]