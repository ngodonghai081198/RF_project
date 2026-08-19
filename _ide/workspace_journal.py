# 2026-08-19T01:16:57.942940
import vitis

client = vitis.create_client()
client.set_workspace(path="RF_project")

advanced_options = client.create_advanced_options_dict(dt_overlay="0")

platform = client.create_platform_component(name = "platform_lcd",hw_design = "$COMPONENT_LOCATION/../design_1_wrapper.xsa",os = "standalone",cpu = "ps7_cortexa9_0",domain_name = "standalone_ps7_cortexa9_0",generate_dtb = False,advanced_options = advanced_options,compiler = "gcc")

comp = client.create_app_component(name="app_component_lcd",platform = "$COMPONENT_LOCATION/../platform_lcd/export/platform_lcd/platform_lcd.xpfm",domain = "standalone_ps7_cortexa9_0")

platform = client.get_component(name="platform_lcd")
status = platform.build()

vitis.dispose()

