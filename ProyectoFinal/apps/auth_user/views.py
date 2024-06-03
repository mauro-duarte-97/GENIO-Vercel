from django.shortcuts import render, redirect
from django.contrib.auth.views import LoginView, LogoutView
from django.views.generic.edit import CreateView
from apps.custom_user.models import CustomUser
# from .models import AuthUserProfile
from .forms import RegistrationForm
from django.contrib import messages


class RegisterUsuarioView(CreateView):
    model = CustomUser
    form_class = RegistrationForm
    template_name = 'index.html'
    success_url = '/auth/login'

    def form_valid(self, form):
        # Procesar el formulario si es válido
        user = form.save(commit=False)
        user.save()
        return super().form_valid(form)

    def form_invalid(self, form):
        # Agregar mensajes de error a la lista de mensajes
        for field, errors in form.errors.items():
            for error in errors:
                messages.error(self.request, f"{field}: {error}")
        return super().form_invalid(form)

class CustomLoginView(LoginView):
    template_name = 'index.html'  # Especifica el nombre del template de inicio de sesión

    def form_invalid(self, form):
        messages.error(
            self.request, "Credenciales incorrectas. Por favor, inténtalo de nuevo."
        )  # Mensaje de error
        return super().form_invalid(form)

class CustomLogoutView(LogoutView):
    template_name = "index.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context

class GoogleLoginView(LoginView):
    template_name = "google_redirect.html"

    def get_context_data(self, **kwargs):
        context = super().get_context_data(**kwargs)
        return context

    # class GoogleAdapter(GoogleOAuth2Adapter):
    #     access_token_url = "https://oauth2.googleapis.com/token"
    #     authorize_url = "https://accounts.google.com/o/oauth2/v2/auth"
    #     profile_url = "https://www.googleapis.com/oauth2/v2/userinfo"

    # adapter = GoogleAdapter
    # callback_url = "http://127.0.0.1:8000/auth/google/"
    # client = OAuth2Client

    # # def get(self, request, *args, **kwargs):
    #     # adapter = GoogleAdapter
    #     # print(adapter)

    #     # client = OAuth2Client
    #     # authorization_url = self.client.get_redirect_uri(self.adapter.authorize_url)
    #     # print(self.client)
    #     # print(self.adapter)
    #     # google_code = request.GET.get('code')
    #     # print('google_code:', google_code)
    #     # code_parsed = urllib.parse.unquote(google_code, safe='~()*!\'')
    #     # print('code_parsed:', code_parsed)
    #     # return redirect(self.adapter.authorize_url)



# def verify_dni(request):
#     if request.method == 'POST':
#         dni = request.POST.get('dni')
#         # Verifica el DNI del usuario aquí
#         # Si el DNI es válido, actualiza el estado de verificación
#         user_profile = request.user.AuthUserProfile
#         user_profile.dni = dni
#         user_profile.is_verified = True
#         user_profile.save()
#         return redirect('perfil_usuario')
#     return render(request, 'verify_dni.html')