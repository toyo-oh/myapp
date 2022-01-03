export default function ({ store, redirect }) {
  if (!store.$auth.user || !store.$auth.user.is_admin) {
    return redirect('/admin_error')
  }
}