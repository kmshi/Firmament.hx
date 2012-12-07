package firmament.core;
import firmament.component.base.FEntityComponent;
import firmament.component.physics.FPhysicsComponentInterface;
import firmament.component.render.FRenderComponentInterface;
import firmament.component.render.FTilesheetRenderComponent;
import firmament.core.FWorld;
import firmament.core.FEntityPool;
import nme.display.BitmapData;
import nme.display.Tilesheet;
import nme.events.Event;
import nme.geom.Point;
import nme.geom.Rectangle;
import firmament.util.FMisc;
import nme.Assets;
 
 /**
  * Class: FEntity 
  * Base class for all entities in Firmament
  * 
  * 
  */
class FEntity extends nme.events.EventDispatcher
{
	var _config:Dynamic;
	var _componentsHash:Hash<Array<FEntityComponent>>;
	var _components:Array<FEntityComponent>;
	var _pool:FEntityPool;
	var _active:Bool;
	var _typeId:String;
	var _listeners : Hash<Dynamic>; 

	public static inline var ACTIVE_STATE_CHANGE = "activeChange";

	/**
	 * Constructor: new
	 * 
	 * Config Paramers:
	 * 	imageScale - [Float] The initial scale value for the sprite.
	 * 	sprite  - [BitmapData] The image to use as a sprite for this entity
	 */
	public function new(config:Dynamic) 
	{
		super();
		this._config = config;
		this._componentsHash = new Hash<Array<FEntityComponent>>();
		_components = new Array<FEntityComponent>();
		_active = true;
		if(!Std.is(config.typeId,String)){
			config.typeId = "Entity_"+Math.floor(Math.random()*10000000);
			
		}
		_typeId = config.typeId;
		_listeners = new Hash();

	}


	public function getTypeId():String{
		return _typeId;
	}
	
	
	/**
	 * Function: getComponent
	 * 
	 * Returns:
	 * 	<FentityComponent>
	 */
	public function getComponent(type:String):Array<FEntityComponent> {
		return this._componentsHash.get(type);
	}

	public function getAllComponents():Array<FEntityComponent>{
		return _components;
	}


	/**
	 * Function: getPhysicsComponent()
	 *	returns a physics component
	 * 
	 * Parameters: 
	 *	none
	 *
	 * Returns:
	 *	<FPysicsComponentInterface>
	 */
	public function getPhysicsComponent():FPhysicsComponentInterface {
		var ca = this.getComponent('physics');
		if(ca!=null){
			return cast(ca[0]);
		}
		return null;
	}

	public function getRenderComponent():FRenderComponentInterface {
		var ca = this.getComponent('render');
		if(ca!=null){
			return cast(ca[0]);
		}
		return null;
	}
	
	
	public function setComponent(component:FEntityComponent) {
		var array:Array<FEntityComponent>;
		array = _componentsHash.get(component.getType());
		if(array == null){
			array = new Array();
			_componentsHash.set(component.getType(),array);
		}
		array.push(component);
		_components.push(component);
		component.setEntity(this);
	}
	
	
	public function getConfig():Dynamic {
		return this._config;
	}

	/**
	 * Function: delete
	 * Deleted the entity
	**/
	public function delete():Void{
		this.dispatchEvent(new Event(FGame.DELETE_ENTITY));
		if(_components!=null){
			for(c in _components){
				c.destruct();
			}
			this._components = null;
			this._config = null;
		}	
		//this.removeListeners();
	}

	public function setActive(active:Bool){
		if(active!=_active){
			_active = active;
			this.dispatchEvent(new Event(ACTIVE_STATE_CHANGE));
		}
	}

	public function isActive():Bool{
		return _active;
	}

	public function setPool(pool:FEntityPool){
		_pool = pool;
	}
	public function getPool(){
		return _pool;
	}
	
	public function returnToPool(){
		
		this.setActive(false);
		
		if(_pool == null){
			throw "Can't return to pool. Pool is null";
		}else{
			_pool.addEntity(this);
		}
		
	}

/*
	//overriding addEventListener so we can remove all listeners when we destruct.
	override public function addEventListener(type : String, listener : Dynamic -> Void, useCapture : Bool = false, priority : Int = 0, useWeakReference : Bool = false) : Void{
			var key : String = type+"_"+useCapture;
		  	if( _listeners.exists(key) ) {
				removeEventListener( type, _listeners.get(key).listener, useCapture );
				_listeners.remove(key);
		  	}
		  	_listeners.set(key,{listener:listener,type:type,useCapture:useCapture});

		  	super.addEventListener( type, listener, useCapture, priority, useWeakReference );
		  	//trace("event listener added: "+key);
	}
*/
	/*
		Helper to remove all event listers. Called when entity is destroyed.
	*//*
	private function removeListeners():Void{
		//throw("remove listeners called");
			try
			{
				for (key in _listeners.keys()) {
					var event = _listeners.get(key);
					removeEventListener( event.type, event.listener, event.useCapture );
					_listeners.remove(key);
				}
			}catch(e:Dynamic){trace("removeListener error: "+e);} //we aren't updating our hash when we remove a listener, so there might be errors
	}*/

	
	
}