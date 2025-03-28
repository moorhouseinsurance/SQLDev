USE [Transactor_Live]
GO
--select * from [Transactor_Live].[dbo].[LIST_ENDORSEMENT] where producttype = '207' and insurer_id = 'TOLEDO'

--=== Shop Insurance                                                                                                              
INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI001',N'TISPAFRY', N'Frying and Cooking Equipment Condition', N'It is a condition precedent to liability under all sections of this policy that: -
'+CHAR(13)+'
a) All cooking equipment used for deep fat frying shall be fitted with a thermostat to prevent fat or oil exceeding 205 degrees centigrade and a high
temperature non self-resetting limit control to shut off the heat source if fat or oil exceeds 230 degrees centigrade;
'+CHAR(13)+'
b) All frying and other cooking ranges, equipment, flues and exhaust ducting will be kept securely fixed and free from contact with combustible
materials;
'+CHAR(13)+'
c) All extraction hoods, canopies, filters and grease traps will be cleaned at least every 2 weeks
'+CHAR(13)+'
d) All extraction ducts will be cleaned regularly and maintained and checked at least once annually by a specialist contractor who certifies
cleaning/servicing to standard TR19 or any subsequent industry standard and must not contain any section that cannot be cleaned or inspected
'+CHAR(13)+'
e) The record of such cleaning and servicing of the extraction ducts will be kept elsewhere other than at the premises and will be made available for
inspection at any time
'+CHAR(13)+'
f) Frying equipment will be installed, used and maintained in accordance with the manufacturer’s instructions
'+CHAR(13)+'
g) Multi purpose fire extinguishers and at least one fire retardant blanket which conforms to the relevant British Standard suitable for extinguishing oil
and fat fires will be kept in close proximity to the working area of the range and maintained ready for use
'+CHAR(13)+'
h) Frying ranges will not be left unattended whilst in use
'+CHAR(13)+'
i) All naked flames (other than pilot lights) and all electrical elements will be turned off at the close of the working day
'+CHAR(13)+'
j) Where ducts pass through any combustible material, it should be cut away for a distance of at least 150mm from the duct and the space filled with
non-combustible insulation.
'+CHAR(13)+'
k) ''Cracklings'' ''batter scraps'' and all waste hot food will be placed only in closed metal containers during the day and removed from the premises at
the close of business each day. All Operators should be trained that spontaneous combustion of cooked food waste can occur.
', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO



INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI002', 'TISPAFSH', N'Food Safety and Hygiene Condition', N'It is a condition precedent to liability under this Policy that the Insured complies with the following:
'+CHAR(13)+'
a) erect suitable signs to warn patrons of hot plates and surfaces
'+CHAR(13)+'
b) ensure that a monitoring system is in place to check the shelf life and quality of foods
'+CHAR(13)+'
c) include in food menus clear warnings regarding ingredients likely to cause allergic reactions
', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI003', 'TISPALLE', N'Loss Of Licence Extension', N'In the event that the Licence in relation to the use of the Premises is
'+CHAR(13)+'
(1) forfeited under the provisions of the appropriate legislation governing such Licences
'+CHAR(13)+'
(2) refused renewal after due application for such renewal to the appropriate authority
at any time during the Period of Insurance the Insurers will pay or make good to you any loss that you may sustain in respect of
'+CHAR(13)+'
(a) depreciation in value of your interest in the Premises by the forfeiture of or refusal to renew your Licence to an amount not exceeding the Limit
of Indemnity stated in the Schedule applicable to this Section
'+CHAR(13)+'
(b) costs and expenses incurred by you with the written consent of the Insurers in connection with any appeal against the forfeiture of or refusal to
renew the Licence
', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI004',N'TISPAELL', N'EXCLUSIONS TO THE LOSS OF LICENCE EXTENSION', N'(1) No claim will arise if under this Section
'+CHAR(13)+'
(a) you are entitled to obtain compensation under the provisions of any Act of Parliament in respect of refusal to renew the Licence
'+CHAR(13)+'
(b) before or after refusal to renew or forfeiture of your Licence the Premises are required for any public purpose by an appropriate authority
'+CHAR(13)+'
(c) surrender refusal to renew or forfeiture arises under or results directly or indirectly from
'+CHAR(13)+'
(i) any scheme of town or country planning improvement redevelopment surrender or reduction
'+CHAR(13)+'
(ii) re-distribution of Licences in connection with redevelopment
'+CHAR(13)+'
(iii) any alteration of the law affecting the granting or surrender refusal to renew or forfeiture of Licences
'+CHAR(13)+'
(2) No claim will arise under this Section unless you prove to the Insurers reasonable satisfaction that such matter was beyond your power or
control if
'+CHAR(13)+'
(a) any alterations to the Premises requiring the consent of the licensing or other necessary authority are made without their approval
'+CHAR(13)+'
(b) the Premises are closed for any period not required by law
'+CHAR(13)+'
(c) the Premises are not maintained in a sanitary or other suitable state of repair or condition
'+CHAR(13)+'
(d) any direction or requirement of the licensing or other authority is not complied with
'+CHAR(13)+'
(e) forfeiture of or refusal to renew your Licence is caused wholly or partly by or through
'+CHAR(13)+'
(i) your misconduct procurement connivance neglect or omission
'+CHAR(13)+'
(ii) your omission to take any step necessary to keep the Licence in force
', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI005', 'TISPASCL', N'SPECIAL CONDITIONS TO THE LOSS OF LICENCE SECTION',N'N B Insurers consider time to be of the essence in complying with the Conditions applying to this Section
'+CHAR(13)+'
(1) On becoming aware of any
'+CHAR(13)+'
(a) complaint against the Premises or the control of it
'+CHAR(13)+'
(b) proceedings against or conviction of the holder of the Licence or manager tenant or occupier of the Premises for any breach of the licensing
law or any matter whatsoever whereby the character or reputation of the person concerned is affected or called into question with regard to such
person''s honesty moral standing or sobriety
'+CHAR(13)+'
(c) change in the tenancy or arrangement of the Premises
'+CHAR(13)+'
(d) transfer or proposed transfer of the Licence
'+CHAR(13)+'
(e) alteration to the purpose for which the Premises are used
'+CHAR(13)+'
(f) objection to renewal or other circumstances which may endanger the Licence or its renewal
you must as soon as possible give notice in writing to the Insurers and supply such additional information and give such assistance as the Insurers
may reasonably require
'+CHAR(13)+'
(2) In the event that the holder of the Licence or manager tenant or occupier of the Premises dies or is incapacitated or deserts the Premises or is
convicted of any offence (where such conviction affects the character or reputation of the convicted person with regard to such person''s honesty
moral standing or sobriety) you will where practicable and at the request of the Insurers procure a suitable replacement to whom the Justices will
transfer the Licence or grant the Licence by way of renewal
'+CHAR(13)+'
(3) In the event of the Licence being forfeited or renewal refused you must
'+CHAR(13)+'
(a) give notice in writing to the Insurers within 24 hours of learning such event stating the grounds upon which the Licence was forfeited or refused
renewal
'+CHAR(13)+'
(b) give all such assistance as the Insurers may require for the purpose of an appeal against such forfeiture or refusal to renew and allow the
Insurers and their solicitors full discretion in the conduct of such proceedings
'+CHAR(13)+'
(c) apply if practicable and required by the Insurers for the granting of such new Licence for the same or alternative premises as may enable you
to continue your Business in a similar or alternative form
'+CHAR(13)+'
(d) provide a statement of your loss (if any) together with such documents statements and accounts as may be reasonably required by the
Insurers to verify the same and also (if required by the Insurers) make a declaration as to the truth accuracy and completeness of your statement and
give the Insurers free access to the Premises and your business books and accounts as may be necessary to ascertain the value of the Premises
and the goodwill of your Business', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI006',N'TISPALED', N'Live Entertainment and Disco Exclusion', N'We shall have no liability under this Policy to provide any indemnity or benefit for any legal liability, directly or indirectly resulting from or in
consequence of the provision of discos and/or live entertainment of any nature.', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI007', 'TISPAMWA', N'Manual Work Away Exclusion (other than Collection & Delivery)', N'We will not indemnify You in respect of any claims arising in connection with any manual work away from Your premises by You or Your Employees
other than for collection and delivery only.', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI008',N'TISPAPPE', N'Personal Protective Equipment Condition', N'It is a condition precedent to Our liability that the use or wearing of Personal Protective Equipment by any Employee is rigorously enforced and that
Personal Protective Equipment is supplied to the Employee and that a formal record is maintained confirming receipt of such equipment.', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI009', 'TISPATMD', N'Increased Theft & Malicious Damage Excess - No Alarm Security', N'In the absence of your premises being protected by an operating security alarm that is subject to a current maintenance contract , the excess is
increased to £1000 for claims arising from or connected to theft , attempted theft & malicious damage', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI010',N'TISPAOWC', N'Outside Waste and other combustibles Storage Condition', N'It is a condition precedent to Our liability that all combustible items are stored at least 5 metres away from the Premises at all times.', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI011', 'TISPAPHE', N'Portable Heater Exclusion', N'It is a condition precedent to Our liability that no paraffin or portable electric or gas heaters or containers are used or stored on the Premises unless
specifically agreed by Us prior to such use or storage.', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI012',N'TISHABT', N'Hair and Beauty Treatment', N' Hair and Beauty Treatment We will not be liable for any person who knows they suffer from skin allergies and or are 6 or more months pregnant and or suffer from any other medical ailments that may be unsuitable for them to receive Professional Treatments unless they are able to produce a medical certificate prior to the commencement of any treatment that certifies they are able to receive such treatments and that a copy of the medical certificate is retained by You for a minimum of 12 months from the date of the first treatment', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI013', 'TISPHTR', N'Treatment Risk', N'It is a condition precedent to Our liability that Professional Treatments including tinting, dyeing, bleaching, permanent waving, straightening of hair or other special treatments of the hair
'+CHAR(13)+'
washing, styling, cutting and drying of the hair
'+CHAR(13)+'
eyebrow plucking, shaping, eyebrow and eyelash tinting
'+CHAR(13)+'
manicure and pedicure (but not chiropody) including nail extensions and nail art
'+CHAR(13)+'
application of cosmetics and body and facial masks
'+CHAR(13)+'
application of proprietary hair removal preparations other than electrolysis
'+CHAR(13)+'
normal hairdressing work on wigs and hairpieces
'+CHAR(13)+'
ear piercing by the gun and stud method
'+CHAR(13)+'
application of false tanning products including airbrush tanning and spray tanning  are peformed by a Qualified Operator that is over the age of 18 years old and has
more than 3 years continuous experience of professional hairdressing or beauty treatments or
'+CHAR(13)+'
completed 2 years technical college training in hairdressing or beauty treatment. Our liability will not exceed £500,000 in any one Period of Insurance.', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI014',N'TISMSC', N'Minimum security clause', N'All doors and windows to the property must be secured by: 
'+CHAR(13)+'
• five-lever mortise deadlocks, to British Standard 3621 on all outside doors; or 
'+CHAR(13)+'
• built-in deadlocking cylinder locks and security bolts if the door is double glazed; or 
'+CHAR(13)+'
• mortise security bolts or other key-operated locks to British Standard 3621 fitted at the top and bottom of each portion of french windows or double sliding patio doors; and 
'+CHAR(13)+'
• all opening sections of the basement, ground floor or easily accessible windows to the property are secured by key-operated  window locks. 
'+CHAR(13)+'
The locks and security bolts must be locked and secured when no authorised person is in the property. 
'+CHAR(13)+'
 All keys must be removed from the locks or bolts and hidden from view whenever the property is left unattended.', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI015', 'TISEIW', N'Electrical Inspection Warranty', N'It is warranted that : 
'+CHAR(13)+'
a) the electrical system at the address to be insured is inspected and tested by a member of the National Inspection Council for Electrical Installation Contracting in accordance with IEE Regulations for electrical installations and a Completion and Inspection Certificate is issued following such inspection 
'+CHAR(13)+'
b) any work specified on such certificates to ensure the electrical installation meets IEE Regulations shall be carried out within 60 days of the inspection  
'+CHAR(13)+'
c) a copy of each Completion and Inspection Certificate must be retained for inspection by insurers as required 
'+CHAR(13)+'
d) the electrical installation is further inspected and tested within the timescale recommended on the Completion and Inspection Certificate.', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI016',N'TISFE', N'Flood Exclusion', N'All sections of this policy exclude loss or damage caused by flood other than directly resulting from escape of water from fixed water tanks, apparatus or pipes. Subject otherwise to Policy Terms, Conditions and Limitations', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI017', 'TISSBEXC', N'Subsidence Exclusion', N'All sections of this policy exclude loss or damage caused by Subsidence . Subject otherwise to Policy Terms, Conditions and Limitations', 0, '198', '154', 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI018',N'TISATM', N'Automated Teller Machinery Exclusion', N'This Policy does not provide indemnity in respect of any automated teller machinery, Subject otherwise to Policy Terms, Conditions and Limitations', 0, '198', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI019', 'TISSTILL', N'Stillage Condition', N'It is a condition that you store contents thar are not fixed 150mm (6 inches) above floor level or any claim resulting from flood or water damage is excluded. Subject otherwise to Policy Terms, Conditions and Limitations', 0, '198', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI020',N'TISOWCSC', N'Outside Waste and other combustibles Storage Condition', N'It is a condition precedent to Our liability that all combustible items are stored at least 5 metres away from the Premises at all times. Subject otherwise to Policy Terms, Conditions and Limitations', 0, '198', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI021', 'TISWASTE', N'Waste Condition (Daily)',N'It is a condition precedent to Our liability that all combustible trade waste and refuse is removed from the Buildings every night.', 0, '198', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISSI022', 'TISFIRE', N'Fire Alarm Condition', N'It is a condition precedent to our Liability that the property must have a bells only fire alarm and that the alarm is in full working order and is maintained on an annual basis.', 0, '198', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO



--====--commercial office 207

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO001',N'TISPAFRY', N'Frying and Cooking Equipment Condition', N'It is a condition precedent to liability under all sections of this policy that: -
'+CHAR(13)+'
a) All cooking equipment used for deep fat frying shall be fitted with a thermostat to prevent fat or oil exceeding 205 degrees centigrade and a high
temperature non self-resetting limit control to shut off the heat source if fat or oil exceeds 230 degrees centigrade;
'+CHAR(13)+'
b) All frying and other cooking ranges, equipment, flues and exhaust ducting will be kept securely fixed and free from contact with combustible
materials;
'+CHAR(13)+'
c) All extraction hoods, canopies, filters and grease traps will be cleaned at least every 2 weeks
'+CHAR(13)+'
d) All extraction ducts will be cleaned regularly and maintained and checked at least once annually by a specialist contractor who certifies
cleaning/servicing to standard TR19 or any subsequent industry standard and must not contain any section that cannot be cleaned or inspected
'+CHAR(13)+'
e) The record of such cleaning and servicing of the extraction ducts will be kept elsewhere other than at the premises and will be made available for
inspection at any time
'+CHAR(13)+'
f) Frying equipment will be installed, used and maintained in accordance with the manufacturer’s instructions
'+CHAR(13)+'
g) Multi purpose fire extinguishers and at least one fire retardant blanket which conforms to the relevant British Standard suitable for extinguishing oil
and fat fires will be kept in close proximity to the working area of the range and maintained ready for use
'+CHAR(13)+'
h) Frying ranges will not be left unattended whilst in use
'+CHAR(13)+'
i) All naked flames (other than pilot lights) and all electrical elements will be turned off at the close of the working day
'+CHAR(13)+'
j) Where ducts pass through any combustible material, it should be cut away for a distance of at least 150mm from the duct and the space filled with
non-combustible insulation.
'+CHAR(13)+'
k) ''Cracklings'' ''batter scraps'' and all waste hot food will be placed only in closed metal containers during the day and removed from the premises at
the close of business each day. All Operators should be trained that spontaneous combustion of cooked food waste can occur.
', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO



INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO002', 'TISPAFSH', N'Food Safety and Hygiene Condition', N'It is a condition precedent to liability under this Policy that the Insured complies with the following:
'+CHAR(13)+'
a) erect suitable signs to warn patrons of hot plates and surfaces
'+CHAR(13)+'
b) ensure that a monitoring system is in place to check the shelf life and quality of foods
'+CHAR(13)+'
c) include in food menus clear warnings regarding ingredients likely to cause allergic reactions
', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO003', 'TISPALLE', N'Loss Of Licence Extension', N'In the event that the Licence in relation to the use of the Premises is
'+CHAR(13)+'
(1) forfeited under the provisions of the appropriate legislation governing such Licences
'+CHAR(13)+'
(2) refused renewal after due application for such renewal to the appropriate authority
at any time during the Period of Insurance the Insurers will pay or make good to you any loss that you may sustain in respect of
'+CHAR(13)+'
(a) depreciation in value of your interest in the Premises by the forfeiture of or refusal to renew your Licence to an amount not exceeding the Limit
of Indemnity stated in the Schedule applicable to this Section
'+CHAR(13)+'
(b) costs and expenses incurred by you with the written consent of the Insurers in connection with any appeal against the forfeiture of or refusal to
renew the Licence
', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO004',N'TISPAELL', N'EXCLUSIONS TO THE LOSS OF LICENCE EXTENSION', N'(1) No claim will arise if under this Section
'+CHAR(13)+'
(a) you are entitled to obtain compensation under the provisions of any Act of Parliament in respect of refusal to renew the Licence
'+CHAR(13)+'
(b) before or after refusal to renew or forfeiture of your Licence the Premises are required for any public purpose by an appropriate authority
'+CHAR(13)+'
(c) surrender refusal to renew or forfeiture arises under or results directly or indirectly from
'+CHAR(13)+'
(i) any scheme of town or country planning improvement redevelopment surrender or reduction
'+CHAR(13)+'
(ii) re-distribution of Licences in connection with redevelopment
'+CHAR(13)+'
(iii) any alteration of the law affecting the granting or surrender refusal to renew or forfeiture of Licences
'+CHAR(13)+'
(2) No claim will arise under this Section unless you prove to the Insurers reasonable satisfaction that such matter was beyond your power or
control if
'+CHAR(13)+'
(a) any alterations to the Premises requiring the consent of the licensing or other necessary authority are made without their approval
'+CHAR(13)+'
(b) the Premises are closed for any period not required by law
'+CHAR(13)+'
(c) the Premises are not maintained in a sanitary or other suitable state of repair or condition
'+CHAR(13)+'
(d) any direction or requirement of the licensing or other authority is not complied with
'+CHAR(13)+'
(e) forfeiture of or refusal to renew your Licence is caused wholly or partly by or through
'+CHAR(13)+'
(i) your misconduct procurement connivance neglect or omission
'+CHAR(13)+'
(ii) your omission to take any step necessary to keep the Licence in force
', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO005', 'TISPASCL', N'SPECIAL CONDITIONS TO THE LOSS OF LICENCE SECTION',N'N B Insurers consider time to be of the essence in complying with the Conditions applying to this Section
'+CHAR(13)+'
(1) On becoming aware of any
'+CHAR(13)+'
(a) complaint against the Premises or the control of it
'+CHAR(13)+'
(b) proceedings against or conviction of the holder of the Licence or manager tenant or occupier of the Premises for any breach of the licensing
law or any matter whatsoever whereby the character or reputation of the person concerned is affected or called into question with regard to such
person''s honesty moral standing or sobriety
'+CHAR(13)+'
(c) change in the tenancy or arrangement of the Premises
'+CHAR(13)+'
(d) transfer or proposed transfer of the Licence
'+CHAR(13)+'
(e) alteration to the purpose for which the Premises are used
'+CHAR(13)+'
(f) objection to renewal or other circumstances which may endanger the Licence or its renewal
you must as soon as possible give notice in writing to the Insurers and supply such additional information and give such assistance as the Insurers
may reasonably require
'+CHAR(13)+'
(2) In the event that the holder of the Licence or manager tenant or occupier of the Premises dies or is incapacitated or deserts the Premises or is
convicted of any offence (where such conviction affects the character or reputation of the convicted person with regard to such person''s honesty
moral standing or sobriety) you will where practicable and at the request of the Insurers procure a suitable replacement to whom the Justices will
transfer the Licence or grant the Licence by way of renewal
'+CHAR(13)+'
(3) In the event of the Licence being forfeited or renewal refused you must
'+CHAR(13)+'
(a) give notice in writing to the Insurers within 24 hours of learning such event stating the grounds upon which the Licence was forfeited or refused
renewal
'+CHAR(13)+'
(b) give all such assistance as the Insurers may require for the purpose of an appeal against such forfeiture or refusal to renew and allow the
Insurers and their solicitors full discretion in the conduct of such proceedings
'+CHAR(13)+'
(c) apply if practicable and required by the Insurers for the granting of such new Licence for the same or alternative premises as may enable you
to continue your Business in a similar or alternative form
'+CHAR(13)+'
(d) provide a statement of your loss (if any) together with such documents statements and accounts as may be reasonably required by the
Insurers to verify the same and also (if required by the Insurers) make a declaration as to the truth accuracy and completeness of your statement and
give the Insurers free access to the Premises and your business books and accounts as may be necessary to ascertain the value of the Premises
and the goodwill of your Business
', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO006',N'TISPALED', N'Live Entertainment and Disco Exclusion', N'We shall have no liability under this Policy to provide any indemnity or benefit for any legal liability, directly or indirectly resulting from or in
consequence of the provision of discos and/or live entertainment of any nature.', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO007', 'TISPAMWA', N'Manual Work Away Exclusion (other than Collection & Delivery)', N'We will not indemnify You in respect of any claims arising in connection with any manual work away from Your premises by You or Your Employees
other than for collection and delivery only.', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO008',N'TISPAPPE', N'Personal Protective Equipment Condition', N'It is a condition precedent to Our liability that the use or wearing of Personal Protective Equipment by any Employee is rigorously enforced and that
Personal Protective Equipment is supplied to the Employee and that a formal record is maintained confirming receipt of such equipment.', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO009', 'TISPATMD', N'Increased Theft & Malicious Damage Excess - No Alarm Security', N'In the absence of your premises being protected by an operating security alarm that is subject to a current maintenance contract , the excess is
increased to £1000 for claims arising from or connected to theft , attempted theft & malicious damage', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO010',N'TISPAOWC', N'Outside Waste and other combustibles Storage Condition', N'It is a condition precedent to Our liability that all combustible items are stored at least 5 metres away from the Premises at all times.', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO011', 'TISPAPHE', N'Portable Heater Exclusion', N'It is a condition precedent to Our liability that no paraffin or portable electric or gas heaters or containers are used or stored on the Premises unless
specifically agreed by Us prior to such use or storage.', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO012',N'TISHABT', N'Hair and Beauty Treatment', N' Hair and Beauty Treatment We will not be liable for any person who knows they suffer from skin allergies and or are 6 or more months pregnant and or suffer from any other medical ailments that may be unsuitable for them to receive Professional Treatments unless they are able to produce a medical certificate prior to the commencement of any treatment that certifies they are able to receive such treatments and that a copy of the medical certificate is retained by You for a minimum of 12 months from the date of the first treatment', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO013', 'TISPHTR', N'Treatment Risk', N'It is a condition precedent to Our liability that Professional Treatments including tinting, dyeing, bleaching, permanent waving, straightening of hair or other special treatments of the hair
'+CHAR(13)+'
washing, styling, cutting and drying of the hair
'+CHAR(13)+'
eyebrow plucking, shaping, eyebrow and eyelash tinting
'+CHAR(13)+'
manicure and pedicure (but not chiropody) including nail extensions and nail art
'+CHAR(13)+'
application of cosmetics and body and facial masks
'+CHAR(13)+'
application of proprietary hair removal preparations other than electrolysis
'+CHAR(13)+'
normal hairdressing work on wigs and hairpieces
'+CHAR(13)+'
ear piercing by the gun and stud method
'+CHAR(13)+'
application of false tanning products including airbrush tanning and spray tanning  are peformed by a Qualified Operator that is over the age of 18 years old and has
more than 3 years continuous experience of professional hairdressing or beauty treatments or
'+CHAR(13)+'
completed 2 years technical college training in hairdressing or beauty treatment. Our liability will not exceed £500,000 in any one Period of Insurance.', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO014',N'TISMSC', N'Minimum security clause', N'All doors and windows to the property must be secured by: 
'+CHAR(13)+'
• five-lever mortise deadlocks, to British Standard 3621 on all outside doors; or 
'+CHAR(13)+'
• built-in deadlocking cylinder locks and security bolts if the door is double glazed; or 
'+CHAR(13)+'
• mortise security bolts or other key-operated locks to British Standard 3621 fitted at the top and bottom of each portion of french windows or double sliding patio doors; and 
'+CHAR(13)+'
• all opening sections of the basement, ground floor or easily accessible windows to the property are secured by key-operated  window locks. 
'+CHAR(13)+'
The locks and security bolts must be locked and secured when no authorised person is in the property. 
'+CHAR(13)+'
 All keys must be removed from the locks or bolts and hidden from view whenever the property is left unattended.', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO015', 'TISEIW', N'Electrical Inspection Warranty', N'It is warranted that : 
'+CHAR(13)+'
a) the electrical system at the address to be insured is inspected and tested by a member of the National Inspection Council for Electrical Installation Contracting in accordance with IEE Regulations for electrical installations and a Completion and Inspection Certificate is issued following such inspection 
'+CHAR(13)+'
b) any work specified on such certificates to ensure the electrical installation meets IEE Regulations shall be carried out within 60 days of the inspection  
'+CHAR(13)+'
c) a copy of each Completion and Inspection Certificate must be retained for inspection by insurers as required 
'+CHAR(13)+'
d) the electrical installation is further inspected and tested within the timescale recommended on the Completion and Inspection Certificate.', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO016',N'TISFE', N'Flood Exclusion', N'All sections of this policy exclude loss or damage caused by flood other than directly resulting from escape of water from fixed water tanks, apparatus or pipes. Subject otherwise to Policy Terms, Conditions and Limitations', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO017', 'TISSBEXC', N'Subsidence Exclusion', N'All sections of this policy exclude loss or damage caused by Subsidence . Subject otherwise to Policy Terms, Conditions and Limitations', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO018',N'TISATM', N'Automated Teller Machinery Exclusion', N'This Policy does not provide indemnity in respect of any automated teller machinery, Subject otherwise to Policy Terms, Conditions and Limitations', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO019', 'TISSTILL', N'Stillage Condition', N'It is a condition that you store contents thar are not fixed 150mm (6 inches) above floor level or any claim resulting from flood or water damage is excluded. Subject otherwise to Policy Terms, Conditions and Limitations', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO020',N'TISOWCSC', N'Outside Waste and other combustibles Storage Condition', N'It is a condition precedent to Our liability that all combustible items are stored at least 5 metres away from the Premises at all times. Subject otherwise to Policy Terms, Conditions and Limitations', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO021', 'TISWASTE', N'Waste Condition (Daily)',N'It is a condition precedent to Our liability that all combustible trade waste and refuse is removed from the Buildings every night.', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO

INSERT INTO [Transactor_Live].[dbo].[LIST_ENDORSEMENT] VALUES ('TISCO022', 'TISFIRE', N'Fire Alarm Condition', N'It is a condition precedent to our Liability that the property must have a bells only fire alarm and that the alarm is in full working order and is maintained on an annual basis.', 0, '207', 154, 'TOLEDO', 0, 'POLICYENDORS')
GO