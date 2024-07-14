
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ДоработатьФормуОтносительноКатегорииСотрудника();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СотрудникПриИзменении(Элемент)
	
	ДоработатьФормуОтносительноКатегорииСотрудника();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДоработатьФормуОтносительноКатегорииСотрудника()
	
	КатегорияСотрудника = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.Сотрудник, "Категория");
	ЭтоКатегорияСпециалист = (КатегорияСотрудника = Справочники.ВКМ_КатегорииСотрудников.Специалисты);
	
	Элементы.ГруппаПроцент.Видимость = ЭтоКатегорияСпециалист;
	
	Если Не ЭтоКатегорияСпециалист Тогда
		Запись.ПроцентОтРабот = 0;
		Запись.НулевойПроцент = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти