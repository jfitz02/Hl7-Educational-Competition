library HelloWorld version '1'

using FHIR version '4.0.0'

include "FHIRHelpers" version '4.0.0' called FHIRHelpers

codesystem "SNOMED": 'http://snomed.info/sct'

code "Benign pigmented skin lesion (finding) code": '734932003' from "SNOMED" display 'Benign pigmented skin lesion (finding)'
code "Basal cell carcinoma (morphologic abdnormality) code": '1338007' from "SNOMED" display 'Basal cell carcinoma (morphologic abdnormality)'
code "MMNICODFOS (morphologic abnormality) code": '2092003' from "SNOMED" display 'MMNICODFOS (morphologic abnormality)'

context Patient

define "isChild":
	AgeInYears()<19

define "Obs_Standard_ValueCodeableConcept":
	([Observation] Obs
      where Obs.value is CodeableConcept).value

define "Obs_Extend_ValueCodeableConcept":
	([Observation] O
      	where O.component.value is not null).component.value

define "Rule_1":
	exists(from "Obs_Standard_ValueCodeableConcept" Obs,
      			"Obs_Extend_ValueCodeableConcept" O
      			where "Benign pigmented skin lesion (finding) code" ~ FHIRHelpers.ToConcept(Obs)
                  or "Benign pigmented skin lesion (finding) code" ~ FHIRHelpers.ToConcept(O))

define "Rule_2":
	exists(from "Obs_Standard_ValueCodeableConcept" Obs,
      			"Obs_Extend_ValueCodeableConcept" O
      			where "Basal cell carcinoma (morphologic abdnormality) code" ~ FHIRHelpers.ToConcept(Obs)
                  or "Basal cell carcinoma (morphologic abdnormality) code" ~ FHIRHelpers.ToConcept(O))

define "Rule_3":
	exists(from "Obs_Standard_ValueCodeableConcept" Obs,
      			"Obs_Extend_ValueCodeableConcept" O
      			where "MMNICODFOS (morphologic abnormality) code" ~ FHIRHelpers.ToConcept(Obs)
                  or "MMNICODFOS (morphologic abnormality) code" ~ FHIRHelpers.ToConcept(O))
                    
define "MDT Care Lebel":
	if "isChild" then '3'
    else if "Rule_3" then '2'
    else if "Rule_2" then '1'
    else if "Rule_1" then 'N/A'
    else 'N/A'
                    
define "Errors":
    null