#from django.shortcuts import render

# class VerificationMiddleware:
#     def __init__(self, get_response):
#         self.get_response = get_response

#     def __call__(self, request):
#         if not request.user.is_authenticated:
#             return self.get_response(request)

#         user_profile = request.user.userprofile
#         if not user_profile.is_verified:
#             # Renderizar una página emergente o redirigir a una página de verificación
#             return render(request, 'verify_dni.html')

#         return self.get_response(request)