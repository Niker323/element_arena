function MoveCamera( data )
{
    g_nBossCameraEntIndex = [];
	g_nBossCameraEntIndex[0] = data["PosX"];
	g_nBossCameraEntIndex[1] = data["PosY"];
	g_nBossCameraEntIndex[2] = data["PosZ"];

	if ( typeof( data["CameraPitch"] ) != "undefined" )
	{
		GameUI.SetCameraPitchMin( data["CameraPitch"] );
		GameUI.SetCameraPitchMax( data["CameraPitch"] );
	}
	if ( typeof( data["CameraDistance"] ) != "undefined" )
	{
		GameUI.SetCameraDistance( data["CameraDistance"] );
	}
	if ( typeof( data["CameraDistance"] ) != "undefined" )
	{
		GameUI.SetCameraLookAtPositionHeightOffset( data["CameraDistance"] );
	}
	
	
    GameUI.SetCameraTargetPosition(g_nBossCameraEntIndex, 1.5);
}

GameEvents.Subscribe( "move_camera", MoveCamera );