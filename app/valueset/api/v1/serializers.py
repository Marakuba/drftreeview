from rest_framework import serializers
from valueset.models import ICD10


class ICD10Serializer(serializers.ModelSerializer):
    class Meta:
        model = ICD10
        exclude = ()
