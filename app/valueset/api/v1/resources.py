from rest_framework.viewsets import ModelViewSet
from valueset.models import ICD10

from .serializers import ICD10Serializer


class ICD10Resource(ModelViewSet):
    serializer_class = ICD10Serializer
    queryset = ICD10.objects.all()
