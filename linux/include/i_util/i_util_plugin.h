#ifndef FLUTTER_PLUGIN_I_UTIL_PLUGIN_H_
#define FLUTTER_PLUGIN_I_UTIL_PLUGIN_H_

#include <flutter_linux/flutter_linux.h>

G_BEGIN_DECLS

#ifdef FLUTTER_PLUGIN_IMPL
#define FLUTTER_PLUGIN_EXPORT __attribute__((visibility("default")))
#else
#define FLUTTER_PLUGIN_EXPORT
#endif

typedef struct _IUtilPlugin IUtilPlugin;
typedef struct {
  GObjectClass parent_class;
} IUtilPluginClass;

FLUTTER_PLUGIN_EXPORT GType i_util_plugin_get_type();

FLUTTER_PLUGIN_EXPORT void i_util_plugin_register_with_registrar(
    FlPluginRegistrar* registrar);

G_END_DECLS

#endif  // FLUTTER_PLUGIN_I_UTIL_PLUGIN_H_
