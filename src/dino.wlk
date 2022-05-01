import wollok.game.*
    
const velocidad = 250

object juego{

	method configurar(){
		game.width(12)
		game.height(8)
		game.title("Dino Game")
		game.addVisual(suelo)
		game.addVisual(cactus)
		game.addVisual(dino)
		game.addVisual(reloj)
		game.addVisual(boton)
		game.addVisual(sol)
	
		keyboard.space().onPressDo{ self.jugar()}
		
		game.onCollideDo(dino,{ obstaculo => obstaculo.chocar()})
		
	} 
	
	method    iniciar(){
		dino.iniciar()
		reloj.iniciar()
		cactus.iniciar()
		boton.iniciar()
	}
	
	method jugar(){
		if (dino.estaVivo()) 
			dino.saltar()
		else {
			game.removeVisual(gameOver)
			self.iniciar()
		}
		
	}
	
	method terminar(){
		game.addVisual(gameOver)
		cactus.detener()
		reloj.detener()
		boton.detener()
		dino.morir()
	}
	
}

object gameOver {
	method position() = game.center()
	method text() = "GAME OVER"
	

}

object reloj {
	
	var tiempo = 0
	
	method text() = tiempo.toString()
	method position() = game.at(1, game.height()-1)
	
	method pasarTiempo() {
		tiempo = tiempo +1
		if (tiempo == 500)
			game.addVisual(quinientos)
		if (tiempo == 507)
			game.removeVisual(quinientos)
			
	}
	method iniciar(){
		tiempo = 0
		game.onTick(100,"tiempo",{self.pasarTiempo()})
	}
	method detener(){
		game.removeTickEvent("tiempo")
	}
	method tiempo(){
		return tiempo
	}
	
}

object quinientos {
	method position()= game.at(0.9, game.height()-7)
	method image()= "500.png"

			
}

object cactus {
	 
	const posicionInicial = game.at(game.width()-2,suelo.position().y())
	var position = posicionInicial

	method image() = "cactus.png"
	method position() = position
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverCactus",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		juego.terminar()
	}
    method detener(){
		game.removeTickEvent("moverCactus")
	}
}

object suelo{
	
	method position() = game.origin().up(1)
	
	method image() = "suelo.png"

}

object boton{
	const posicionInicial = game.at(game.width(),suelo.position().y())
	var position = posicionInicial
	var x=0
	
	method position()= position
	method image()= "butonn.png"
	
	method iniciar(){
		position = posicionInicial
		game.onTick(velocidad,"moverBoton",{self.mover()})
	}
	
	method mover(){
		position = position.left(1)
		if (position.x() == -1)
			position = posicionInicial
	}
	
	method chocar(){
		x=x+1
		if ((x%2) != 0) {
			game.removeVisual(sol)
			game.addVisual(luna)
			}
			else {
				game.addVisual(sol)
				game.removeVisual(luna)
			}

	}
	
    method detener(){
		game.removeTickEvent("moverBoton")
	}
}

object sol{
	
	method image()= "sol.1.png"
	method position()= game.at(game.width()-2,game.height()-2)
}

object luna{
	
	method image()= "luna.1.png"
	method position()= game.at(game.width()-2,game.height()-2)
}

object dino {
	var vivo = true
	var position = game.at(1,suelo.position().y())
	
	method image() = "dino.png"
	method position() = position
	
	method saltar(){
		if(position.y() == suelo.position().y()) {
			self.subir()
			game.schedule(velocidad*3,{self.bajar()})
		}
	}
	
	method subir(){
		position = position.up(1)
	}
	
	method bajar(){
		position = position.down(1)
	}
	method morir(){
		game.say(self,"¡Auch!")
		vivo = false
	}
	method iniciar() {
		vivo = true
	}
	method estaVivo() {
		return vivo
	}
}