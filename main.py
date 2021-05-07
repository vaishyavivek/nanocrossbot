# This Python file uses the following encoding: utf-8
import sys

from PySide2.QtWidgets import QApplication
from PySide2.QtCore import QObject, Slot, Signal
from PySide2.QtQml import QQmlApplicationEngine


from chatterbot import ChatBot
from chatterbot.trainers import ChatterBotCorpusTrainer
from chatterbot.trainers import ListTrainer
from google_trans_new import google_translator


class NanoCrossBot(QObject):
    def __init__(self):
        super().__init__()
        self.translator = google_translator()
        self.chatbot = ChatBot('Cross Lingual Chatbot')

    setResponse = Signal(str, arguments=['res'])

    @Slot()
    def initBot(self):
        conversation = open('chat.txt', 'r').readlines()
        trainer = ListTrainer(self.chatbot)
        trainer.train(conversation)


    @Slot(str)
    def getResponse(self, chat):
        translate_req = self.translator.translate(chat.strip(), lang_tgt='en')
        detect_result = self.translator.detect(chat)

        res = self.chatbot.get_response(translate_req)
        translate_res = self.translator.translate(res, lang_tgt=detect_result[0])
        self.setResponse.emit(translate_res)


if __name__ == "__main__":

    app = QApplication(sys.argv)

    engine = QQmlApplicationEngine()
    ctx = engine.rootContext()

    bot = NanoCrossBot()
    ctx.setContextProperty("bot", bot)

    engine.load("main.qml")
    sys.exit(app.exec_())
