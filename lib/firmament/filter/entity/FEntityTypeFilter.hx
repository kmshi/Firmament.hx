package firmament.filter.entity;

import firmament.core.FEntity;

class FEntityTypeFilter extends FEntityFilter{

	var _type:String;
	public function new(){
		super();
	}

	//returns true if the entity matches the criteria of the filter
	override public function filterEntity(entity:FEntity,?options:Dynamic=null):Bool{
		if(Std.is(options.typeId,String)){
			if(entity.hasTag(options.tag))return true;
		}else if(Std.is(options.tags,Array)){
			var arr:Array<String> = options.typeIds;
			for (tag in arr){
				if(entity.hasTag(tag)) return true;
			}
		}
		return false;
	}

	


}