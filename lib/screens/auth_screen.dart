import 'package:flutter/material.dart';
import 'package:claycraft_google_gen_ai/services/local_storage.dart';
import 'package:claycraft_google_gen_ai/models/user.dart';
import 'package:claycraft_google_gen_ai/screens/home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final LocalStorageService _storage = LocalStorageService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _isLogin = true;
  bool _isLoading = false;
  UserRole _selectedRole = UserRole.buyer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo and Title
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.emoji_objects,
                      size: 60,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'ClayCraft',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Connect with pottery artisans worldwide',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
                  
                  // Auth Form
                  Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Toggle Login/Register
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => setState(() => _isLogin = true),
                                    style: TextButton.styleFrom(
                                      backgroundColor: _isLogin ? Theme.of(context).colorScheme.primary : null,
                                      foregroundColor: _isLogin ? Theme.of(context).colorScheme.onPrimary : null,
                                    ),
                                    child: const Text('Login'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () => setState(() => _isLogin = false),
                                    style: TextButton.styleFrom(
                                      backgroundColor: !_isLogin ? Theme.of(context).colorScheme.primary : null,
                                      foregroundColor: !_isLogin ? Theme.of(context).colorScheme.onPrimary : null,
                                    ),
                                    child: const Text('Register'),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            
                            // Name field (only for registration)
                            if (!_isLogin) ...[
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Full Name',
                                  prefixIcon: Icon(Icons.person),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                            ],
                            
                            // Email field
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                }
                                if (!value.contains('@')) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            // Password field
                            TextFormField(
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock),
                                border: OutlineInputBorder(),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (!_isLogin && value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            
                            // Role selection (only for registration)
                            if (!_isLogin) ...[
                              const SizedBox(height: 16),
                              Text(
                                'I am a:',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: RadioListTile<UserRole>(
                                      title: const Text('Buyer'),
                                      subtitle: const Text('Looking for pottery'),
                                      value: UserRole.buyer,
                                      groupValue: _selectedRole,
                                      onChanged: (value) => setState(() => _selectedRole = value!),
                                    ),
                                  ),
                                  Expanded(
                                    child: RadioListTile<UserRole>(
                                      title: const Text('Artisan'),
                                      subtitle: const Text('Creating pottery'),
                                      value: UserRole.artisan,
                                      groupValue: _selectedRole,
                                      onChanged: (value) => setState(() => _selectedRole = value!),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            
                            const SizedBox(height: 24),
                            
                            // Submit button
                            ElevatedButton(
                              onPressed: _isLoading ? null : _handleAuth,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator()
                                  : Text(_isLogin ? 'Login' : 'Register'),
                            ),
                            
                            if (_isLogin) ...[
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: _handleDemoLogin,
                                child: const Text('Try Demo Account'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleAuth() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (_isLogin) {
        await _storage.login(_emailController.text, _passwordController.text);
      } else {
        final user = User(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          name: _nameController.text,
          email: _emailController.text,
          role: _selectedRole,
          createdAt: DateTime.now(),
        );
        await _storage.register(user);
      }
      
      if (mounted) {
        // Force rebuild of parent widget
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleDemoLogin() async {
    setState(() => _isLoading = true);
    
    // Use first sample buyer for demo
    await _storage.login('demo@claycraft.com', 'password');
    
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

