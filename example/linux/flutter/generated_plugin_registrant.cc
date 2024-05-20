//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <i_util/i_util_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) i_util_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "IUtilPlugin");
  i_util_plugin_register_with_registrar(i_util_registrar);
}
