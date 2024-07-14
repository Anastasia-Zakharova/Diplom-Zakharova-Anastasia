
#Область ПрограммныйИнтерфейс

#Область ПолучениеДанных

// Получить обновления get updates.
// 
// Параметры:
//  offset - Число -  Offset
//  limit - Число -  Limit
//  timeout - Число -  Timeout
// 
// Возвращаемое значение:
//  Неопределено, Произвольный -  Получить обновления get updates
Функция ПолучитьОбновления_getUpdates(Offset = 0, Limit = 0, Timeout = 0) Экспорт
	
	//getUpdates - этот метод используется для получения обновлений через long polling (wiki).
	//Ответ возвращается в виде массива объектов Update.
	ИмяМетода = "getUpdates";
	
	ПараметрыМетода = Новый Соответствие;
	
	//offset - Идентификатор первого возвращаемого обновления.
	//По умолчанию возвращаются обновления, начиная с самого раннего неподтвержденного обновления.
	ИдентификаторОбновления = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Offset);
	ПараметрыМетода.Вставить("offset", ИдентификаторОбновления);
	
	//limit - Ограничивает количество обновлений, которые необходимо восстановить.
	//Допустимы значения от 1 до 100. По умолчанию используется значение 100.
	КоличествоОбновлений = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Limit);
	ПараметрыМетода.Вставить("limit", КоличествоОбновлений);
	
	//timeout - Время ожидания в секундах для длительного опроса.
	//Значение по умолчанию равно 0, т.е. обычный короткий опрос.
	ВремяОжидания = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Timeout);
	ПараметрыМетода.Вставить("timeout", ВремяОжидания);
	
	
	РезультатСтрокаJSON = ВКМ_ОтправкаЗапросаТелеграм.ОтправитьHTTPЗапрос(ИмяМетода, ПараметрыМетода);
	
	РезультатДанныеJSON = ВКМ_СлужебныеТелеграм.ОбработатьJSON(РезультатСтрокаJSON);
	
	Возврат РезультатДанныеJSON;
	
КонецФункции

#КонецОбласти

#Область ОтправкаДанных

// Отправить сообщение send message.
// 
// Параметры:
//  chat_id - Число - Chat id
//  text - Строка - Text
//  parse_mode - Неопределено -  Parse mode
//  disable_web_page_preview - Неопределено -  Disable web page preview
//  disable_notification - Неопределено -  Disable notification
//  reply_to_message_id - Число -  Reply to message id
//  reply_markup - Неопределено -  Reply markup
// 
// Возвращаемое значение:
//  Неопределено, Произвольный -  Отправить сообщение send message
//@skip-check method-too-many-params
Функция ОтправитьСообщение_sendMessage(Chat_id, Text, Parse_mode = Неопределено, Disable_web_page_preview = Неопределено, Disable_notification = Неопределено, Reply_to_message_id = 0, Reply_markup = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Chat_id) ИЛИ Не ЗначениеЗаполнено(Text) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	//sendMessage - это метод для отправки текстовых сообщений.
	//В случае успеха отправленное сообщение возвращается.
	ИмяМетода = "sendMessage";
	
	ИдентификаторЧата = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Chat_id);
	ТекстСообщения = Text;
	ЯзыкРазметкиТекста = Строка(Parse_mode);
	ПредварительныйПросмотрСсылок = ВКМ_СлужебныеТелеграм.ФорматироватьБулево(Disable_web_page_preview);
	УведомленияБезЗвука = ВКМ_СлужебныеТелеграм.ФорматироватьБулево(Disable_notification);
	ИдентификаторОтветаНаСообщение = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Reply_to_message_id);
	ДополнительнаяКлавиатура = ВКМ_СлужебныеТелеграм.СформироватьJSON(Reply_markup);
	
	ПараметрыМетода = Новый Соответствие;
	ПараметрыМетода.Вставить("chat_id", ИдентификаторЧата);
	ПараметрыМетода.Вставить("text", ТекстСообщения);
	ПараметрыМетода.Вставить("parse_mode", ЯзыкРазметкиТекста);
	ПараметрыМетода.Вставить("disable_web_page_preview",ПредварительныйПросмотрСсылок );
	ПараметрыМетода.Вставить("disable_notification", УведомленияБезЗвука);
	ПараметрыМетода.Вставить("reply_to_message_id", ИдентификаторОтветаНаСообщение);
	ПараметрыМетода.Вставить("reply_markup", ДополнительнаяКлавиатура);
	
	РезультатСтрокаJSON = ВКМ_ОтправкаЗапросаТелеграм.ОтправитьHTTPЗапрос(ИмяМетода, ПараметрыМетода);
	
	РезультатДанныеJSON = ВКМ_СлужебныеТелеграм.ОбработатьJSON(РезультатСтрокаJSON);
	
	Возврат РезультатДанныеJSON;
	
КонецФункции

// Отправить фото send photo.
// 
// Параметры:
//  ИмяФайлаПолное - Строка - Имя файла полное
//  Chat_id - Число -  Chat id
//  Photo - Неопределено -  Photo
//  Caption - Неопределено -  Caption
//  Disable_notification - Неопределено -  Disable notification
//  Reply_to_message_id - Неопределено -  Reply to message id
//  Reply_markup - Неопределено -  Reply markup
// 
// Возвращаемое значение:
//  Неопределено, Произвольный -  Отправить фото send photo
//@skip-check method-too-many-params
Функция ОтправитьФото_sendPhoto(ИмяФайлаПолное, Chat_id, Photo = Неопределено, Caption = Неопределено, Disable_notification = Неопределено, Reply_to_message_id = Неопределено, Reply_markup = Неопределено) Экспорт
	
	Если Не ЗначениеЗаполнено(Chat_id) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	//sendPhoto - это метод для отправки фотографий.
	//В случае успеха отправленное сообщение будет возвращено.
	ИмяМетода = "sendPhoto";
	
	ИдентификаторЧата = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Chat_id);
	ФотоДляОтправки = Photo;
	ПодписьФотографии = Caption;
	УведомленияБезЗвука = ВКМ_СлужебныеТелеграм.ФорматироватьБулево(Disable_notification);
	ИдентификаторОтветаНаСообщение = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Reply_to_message_id);
	ДополнительнаяКлавиатура = Reply_markup;
	
	ПараметрыМетода = Новый Соответствие;
	ПараметрыМетода.Вставить("chat_id", ИдентификаторЧата);
	ПараметрыМетода.Вставить("photo", ФотоДляОтправки);
	ПараметрыМетода.Вставить("caption", ПодписьФотографии);
	ПараметрыМетода.Вставить("disable_notification", УведомленияБезЗвука);
	ПараметрыМетода.Вставить("reply_to_message_id", ИдентификаторОтветаНаСообщение);
	ПараметрыМетода.Вставить("reply_markup", ДополнительнаяКлавиатура);
	
	ИмяДанных = "photo";
	ТипКонтентаДанных = "image/jpeg";
	ДанныеМетода = СформироватьДанные(ФотоДляОтправки, ИмяФайлаПолное, ИмяДанных, ТипКонтентаДанных);
	
	РезультатСтрокаJSON = ВКМ_ОтправкаЗапросаТелеграм.ОтправитьHTTPЗапрос(ИмяМетода, ПараметрыМетода, ДанныеМетода);
	
	РезультатДанныеJSON = ВКМ_СлужебныеТелеграм.ОбработатьJSON(РезультатСтрокаJSON);
	
	Возврат РезультатДанныеJSON;
	
КонецФункции

// Отправить аудио send audio.
// 
// Параметры:
//  ИмяФайлаПолное - Строка - Имя файла полное
//  Chat_id - Число - Chat id
//  Audio - Неопределено -  Audio
//  Caption - Неопределено -  Caption
//  Duration - Число -  Duration
//  Performer - Неопределено -  Performer
//  Title - Неопределено -  Title
//  Disable_notification - Неопределено -  Disable notification
//  Reply_to_message_id - Неопределено -  Reply to message id
//  Reply_markup - Неопределено -  Reply markup
// 
// Возвращаемое значение:
//  Неопределено, Произвольный -  Отправить аудио send audio
//@skip-check method-too-many-params
Функция ОтправитьАудио_sendAudio(ИмяФайлаПолное, Chat_id, Audio = Неопределено, Caption = Неопределено, Duration = 0, Performer = Неопределено, Title = Неопределено, Disable_notification = Неопределено, Reply_to_message_id = Неопределено, Reply_markup = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Chat_id) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	//sendAudio - это метод для отправки аудиофайлов. Аудиозаписи должны быть в формате .mp3.
	//В случае успеха отправленное сообщение будет возвращено.
	ИмяМетода = "sendAudio";
	
	ИдентификаторЧата = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Chat_id);
	АудиоДляОтправки = Audio;
	ПодписьАудио = Caption;
	ПродолжительностьАудио = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Duration);
	Исполнитель = Performer;
	НазваниеТрека = Title;
	УведомленияБезЗвука = ВКМ_СлужебныеТелеграм.ФорматироватьБулево(Disable_notification);
	ИдентификаторОтветаНаСообщение = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Reply_to_message_id);
	ДополнительнаяКлавиатура = Reply_markup;
	
	ПараметрыМетода = Новый Соответствие;
	ПараметрыМетода.Вставить("chat_id", ИдентификаторЧата);
	ПараметрыМетода.Вставить("audio", АудиоДляОтправки);
	ПараметрыМетода.Вставить("caption", ПодписьАудио);
	ПараметрыМетода.Вставить("duration", ПродолжительностьАудио);
	ПараметрыМетода.Вставить("performer", Исполнитель);
	ПараметрыМетода.Вставить("title", НазваниеТрека);
	ПараметрыМетода.Вставить("disable_notification", УведомленияБезЗвука);
	ПараметрыМетода.Вставить("reply_to_message_id", ИдентификаторОтветаНаСообщение);
	ПараметрыМетода.Вставить("reply_markup", ДополнительнаяКлавиатура);
	
	ИмяДанных = "audio";
	ТипКонтентаДанных = "audio/mpeg";
	ДанныеМетода = СформироватьДанные(АудиоДляОтправки, ИмяФайлаПолное, ИмяДанных, ТипКонтентаДанных);
	
	РезультатСтрокаJSON = ВКМ_ОтправкаЗапросаТелеграм.ОтправитьHTTPЗапрос(ИмяМетода, ПараметрыМетода, ДанныеМетода);
	
	РезультатДанныеJSON = ВКМ_СлужебныеТелеграм.ОбработатьJSON(РезультатСтрокаJSON);
	
	Возврат РезультатДанныеJSON;
	
КонецФункции

// Отправить контакт send contact.
// 
// Параметры:
//  Chat_id - Число - Chat id
//  Phone_number - Строка - Phone number
//  First_name - Строка - First name
//  Last_name - Неопределено -  Last name
//  Disable_notification - Неопределено -  Disable notification
//  Reply_to_message_id - Число -  Reply to message id
//  Reply_markup - Неопределено -  Reply markup
// 
// Возвращаемое значение:
//  Неопределено, Произвольный -  Отправить контакт send contact
//@skip-check method-too-many-params
Функция ОтправитьКонтакт_sendContact(Chat_id, Phone_number, First_name, Last_name = Неопределено, Disable_notification = Неопределено, Reply_to_message_id = 0, Reply_markup = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(chat_id) ИЛИ
		НЕ ЗначениеЗаполнено(phone_number) ИЛИ
		НЕ ЗначениеЗаполнено(first_name) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	//sendContact - это метод для отправки телефонных контактов.
	//В случае успеха отправленное сообщение будет возвращено.
	ИмяМетода = "sendContact";
	
	ИдентификаторЧата = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Chat_id);
	ТелефонныйНомер = СокрЛП(Phone_number);
	ПервоеИмя = СокрЛП(First_name);
	ПоследнееИмя = Last_name;
	УведомленияБезЗвука = ВКМ_СлужебныеТелеграм.ФорматироватьБулево(Disable_notification);
	ИдентификаторОтветаНаСообщение = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Reply_to_message_id);
	ДополнительнаяКлавиатура = Reply_markup;
	
	ПараметрыМетода = Новый Соответствие;
	ПараметрыМетода.Вставить("chat_id", ИдентификаторЧата);
	ПараметрыМетода.Вставить("phone_number", ТелефонныйНомер);
	ПараметрыМетода.Вставить("first_name", ПервоеИмя);
	ПараметрыМетода.Вставить("last_name", ПоследнееИмя);
	ПараметрыМетода.Вставить("disable_notification", УведомленияБезЗвука);
	ПараметрыМетода.Вставить("reply_to_message_id", ИдентификаторОтветаНаСообщение);
	ПараметрыМетода.Вставить("reply_markup", ДополнительнаяКлавиатура);
	
	РезультатСтрокаJSON = ВКМ_ОтправкаЗапросаТелеграм.ОтправитьHTTPЗапрос(ИмяМетода, ПараметрыМетода);
	
	РезультатДанныеJSON = ВКМ_СлужебныеТелеграм.ОбработатьJSON(РезультатСтрокаJSON);
	
	Возврат РезультатДанныеJSON;
	
КонецФункции

// Отправить месторасположение send venue.
// 
// Параметры:
//  Chat_id - Число - Chat id
//  Latitude - Число - Latitude
//  Longitude - Число - Longitude
//  Title - Строка - Title
//  Address - Строка - Address
//  Foursquare_id - Неопределено -  Foursquare id
//  Disable_notification - Неопределено -  Disable notification
//  Reply_to_message_id - Число -  Reply to message id
//  Reply_markup - Неопределено -  Reply markup
// 
// Возвращаемое значение:
//  Неопределено, Произвольный -  Отправить месторасположение send venue
//@skip-check method-too-many-params
Функция ОтправитьМесторасположение_sendVenue(Chat_id, Latitude, Longitude, Title, Address, Foursquare_id = Неопределено, Disable_notification = Неопределено, Reply_to_message_id = 0, Reply_markup = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Chat_id) ИЛИ
		НЕ ЗначениеЗаполнено(Latitude) ИЛИ
		НЕ ЗначениеЗаполнено(Longitude) ИЛИ
		НЕ ЗначениеЗаполнено(Title) ИЛИ
		НЕ ЗначениеЗаполнено(Address) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	//sendVenue - это метод для отправки информации о месте проведения.
	//В случае успеха отправленное сообщение возвращается.
	ИмяМетода = "sendVenue";
	
	ИдентификаторЧата = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Chat_id);
	ШиротаМеста = ВКМ_СлужебныеТелеграм.ФорматироватьКоординатыВСтроку(Latitude);
	ДолготаМеста = ВКМ_СлужебныеТелеграм.ФорматироватьКоординатыВСтроку(Longitude);
	НазваниеМеста = Title;
	АдресМеста = Address;
	ИдентификаторЧетырехугольника = Foursquare_id;
	УведомленияБезЗвука = ВКМ_СлужебныеТелеграм.ФорматироватьБулево(Disable_notification);
	ИдентификаторОтветаНаСообщение = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Reply_to_message_id);
	ДополнительнаяКлавиатура = Reply_markup;
	
	ПараметрыМетода = Новый Соответствие;
	ПараметрыМетода.Вставить("chat_id", ИдентификаторЧата);
	ПараметрыМетода.Вставить("latitude", ШиротаМеста);
	ПараметрыМетода.Вставить("longitude", ДолготаМеста);
	ПараметрыМетода.Вставить("title", НазваниеМеста);
	ПараметрыМетода.Вставить("address", АдресМеста);
	ПараметрыМетода.Вставить("foursquare_id", ИдентификаторЧетырехугольника);
	ПараметрыМетода.Вставить("disable_notification", УведомленияБезЗвука);
	ПараметрыМетода.Вставить("reply_to_message_id", ИдентификаторОтветаНаСообщение);
	ПараметрыМетода.Вставить("reply_markup", ДополнительнаяКлавиатура);
	
	РезультатСтрокаJSON = ВКМ_ОтправкаЗапросаТелеграм.ОтправитьHTTPЗапрос(ИмяМетода, ПараметрыМетода);
	
	РезультатДанныеJSON = ВКМ_СлужебныеТелеграм.ОбработатьJSON(РезультатСтрокаJSON);
	
	Возврат РезультатДанныеJSON;
	
КонецФункции

// Отправить документ send document.
// 
// Параметры:
//  ИмяФайлаПолное - Строка - Имя файла полное
//  Chat_id - Число - Chat id
//  Document - Неопределено -  Document
//  Caption - Неопределено -  Caption
//  Disable_notification - Неопределено -  Disable notification
//  Reply_to_message_id - Число -  Reply to message id
//  Reply_markup - Неопределено -  Reply markup
// 
// Возвращаемое значение:
//  Неопределено, Произвольный -  Отправить документ send document
//@skip-check method-too-many-params
Функция ОтправитьДокумент_sendDocument(ИмяФайлаПолное, Chat_id, Document = Неопределено, Caption = Неопределено, Disable_notification = Неопределено, Reply_to_message_id = 0, Reply_markup = Неопределено) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Chat_id) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	//sendDocument - это метод для отправки обычных файлов.
	//В случае успеха отправленное сообщение возвращается.
	ИмяМетода = "sendDocument";
	
	ИдентификаторЧата = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Chat_id);
	ДокументДляОтправки = Document;
	ПодписьДокумента = Caption;
	УведомленияБезЗвука = ВКМ_СлужебныеТелеграм.ФорматироватьБулево(Disable_notification);
	ИдентификаторОтветаНаСообщение = ВКМ_СлужебныеТелеграм.ФорматироватьЧислоВСтроку(Reply_to_message_id);
	ДополнительнаяКлавиатура = Reply_markup;
	
	ПараметрыМетода = Новый Соответствие;
	ПараметрыМетода.Вставить("chat_id", ИдентификаторЧата);
	ПараметрыМетода.Вставить("document", ДокументДляОтправки);
	ПараметрыМетода.Вставить("caption", ПодписьДокумента);
	ПараметрыМетода.Вставить("disable_notification", УведомленияБезЗвука);
	ПараметрыМетода.Вставить("reply_to_message_id", ИдентификаторОтветаНаСообщение);
	ПараметрыМетода.Вставить("reply_markup", ДополнительнаяКлавиатура);
	
	ИмяДанных = "document";
	
	Если СтрЗаканчиваетсяНа(".pdf", ИмяФайлаПолное) Тогда
		ТипКонтентаДанных = "application/pdf";
	КонецЕсли;
	
	Если СтрЗаканчиваетсяНа(".doc", ИмяФайлаПолное) Тогда
		ТипКонтентаДанных = "application/msword";
	КонецЕсли;
	
	ДанныеМетода = СформироватьДанные(ДокументДляОтправки, ИмяФайлаПолное, ИмяДанных, ТипКонтентаДанных);
	
	РезультатСтрокаJSON = ВКМ_ОтправкаЗапросаТелеграм.ОтправитьHTTPЗапрос(ИмяМетода, ПараметрыМетода, ДанныеМетода);
	
	РезультатДанныеJSON = ВКМ_СлужебныеТелеграм.ОбработатьJSON(РезультатСтрокаJSON);
	
	Возврат РезультатДанныеJSON;
	
КонецФункции

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция СформироватьДанные(ИсходныеДанные, ИмяФайлаПолное, ИмяДанных, ТипКонтентаДанных)
	
	Если Не ЗначениеЗаполнено(ИсходныеДанные) Тогда
		
		ДлинаИмени = СтрДлина(ИмяФайлаПолное) - СтрНайти(ИмяФайлаПолное, "\", НаправлениеПоиска.СКонца);
		ИмяФайла = Прав(ИмяФайлаПолное, ДлинаИмени);
		
		Данные = Новый Соответствие;
		Данные.Вставить("Boundary", СтрШаблон("----%1", Строка(Новый УникальныйИдентификатор())));
		Данные.Вставить("ИмяФайлаПолное", ИмяФайлаПолное);
		Данные.Вставить("ИмяФайла", ИмяФайла);
		Данные.Вставить("name", ИмяДанных);
		Данные.Вставить("Content-Type", ТипКонтентаДанных);
		
		Возврат Данные;
		
	Иначе
		
		Возврат Неопределено
		
	КонецЕсли;
	
КонецФункции

#КонецОбласти