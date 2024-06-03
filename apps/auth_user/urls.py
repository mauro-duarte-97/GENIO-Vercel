from django.urls import path
from .views import CustomLoginView, RegisterUsuarioView, CustomLogoutView, GoogleLoginView
from django.contrib.auth import views as auth_views
# from .views import google_auth

urlpatterns = [
    path("", CustomLoginView.as_view(), name="index"),
    path('register/', RegisterUsuarioView.as_view(), name='registrar_usuario'),
    path("login/", CustomLoginView.as_view(), name="login"),
    path("", CustomLogoutView.as_view(), name="logout"),
    #CAMBIO DE CONTRASEÑA
    path('reset_password/', auth_views.PasswordResetView.as_view(template_name="password_reset.html"), name='password_reset'),
    path('reset_password_send/', auth_views.PasswordResetDoneView.as_view(template_name="password_notificacion_reset.html"), name='password_reset_done'),
    path('reset/<uidb64>/<token>', auth_views.PasswordResetConfirmView.as_view(template_name="password_confirm.html"), name='password_reset_confirm'),
    path('reset_password_complete/', auth_views.PasswordResetCompleteView.as_view(template_name="password_reset_complete.html"), name='password_reset_complete'),
    # GOOGLE AUTH
    path('google/', GoogleLoginView.as_view() , name='google-login'),
]