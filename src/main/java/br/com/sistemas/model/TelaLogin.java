import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class TelaLogin extends JFrame {
    private JTextField txtCpf;
    private JPasswordField txtSenha;
    private JComboBox<String> comboTipoUsuario;

    public TelaLogin() {
        setTitle("Login");
        setSize(300, 250);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        JPanel painel = new JPanel();
        painel.setLayout(new GridLayout(5, 2));

        painel.add(new JLabel("CPF:"));
        txtCpf = new JTextField();
        painel.add(txtCpf);

        painel.add(new JLabel("Senha:"));
        txtSenha = new JPasswordField();
        painel.add(txtSenha);

        painel.add(new JLabel("Tipo de Usuário:"));
        comboTipoUsuario = new JComboBox<>(new String[]{"Admin", "Atendente"});
        painel.add(comboTipoUsuario);

        JButton btnLogin = new JButton("Login");
        btnLogin.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                realizarLogin();
            }
        });
        painel.add(btnLogin);

        JButton btnCadastrar = new JButton("Cadastrar");
        btnCadastrar.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                TelaCadastro telaCadastro = new TelaCadastro();
                telaCadastro.setVisible(true);
                dispose(); // Fecha a tela de login
            }
        });
        painel.add(btnCadastrar);

        add(painel);
    }

    private void realizarLogin() {
        String cpf = txtCpf.getText();
        String senha = new String(txtSenha.getPassword());
        String tipoUsuario = (String) comboTipoUsuario.getSelectedItem();

        // Conexão com o banco de dados
        String url = "jdbc:postgresql://localhost:5432/seu_banco_de_dados"; // Altere para o seu banco de dados
        String usuario = "seu_usuario"; // Altere para o seu usuário
        String senhaBanco = "sua_senha"; // Altere para a sua senha

        try (Connection conn = DriverManager.getConnection(url, usuario, senhaBanco)) {
            String sql = "SELECT fun_cargo FROM tb_funcionarios WHERE fun_cpf = ? AND fun_senha = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, cpf);
            stmt.setString(2, senha);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String cargo = rs.getString("fun_cargo");
                // Login bem-sucedido
                JOptionPane.showMessageDialog(this, "Login bem-sucedido!");

                // Verifica se o cargo do usuário corresponde ao tipo selecionado
                if (tipoUsuario.equalsIgnoreCase("Admin") && "admin".equalsIgnoreCase(cargo)) {
                    TelaAdmin telaAdmin = new TelaAdmin();
                    telaAdmin.setVisible(true);
                } else if (tipoUsuario.equalsIgnoreCase("Atendente") && "atendente".equalsIgnoreCase(cargo)) {
                    TelaAtendente telaAtendente = new TelaAtendente();
                    telaAtendente.setVisible(true);
                } else {
                    JOptionPane.showMessageDialog(this, "Tipo de usuário não corresponde ao cargo.", "Erro", JOptionPane.ERROR_MESSAGE);
                }

                dispose(); // Fecha a tela de login
            } else {
                // Login falhou
                JOptionPane.showMessageDialog(this, "CPF ou senha incorretos.", "Erro", JOptionPane.ERROR_MESSAGE);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
            JOptionPane.showMessageDialog(this, "Erro ao conectar ao banco de dados.", "Erro", JOptionPane.ERROR_MESSAGE);
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            TelaLogin telaLogin = new TelaLogin();
            telaLogin.setVisible(true);
        });
    }
}

// Tela para Admin
class TelaAdmin extends JFrame {
    public TelaAdmin() {
        setTitle("Tela Admin");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        JLabel label = new JLabel("Bem-vindo à Tela Admin");
        add(label);
    }
}

// Tela para Atendente
class TelaAtendente extends JFrame {
    public TelaAtendente() {
        setTitle("Tela Atendente");
        setSize(400, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        JLabel label = new JLabel("Bem-vindo à Tela Atendente");
        add(label);
    }
}

// Tela de Cadastro
class TelaCadastro extends JFrame {
    private JTextField txtCpf;
    private JPasswordField txtSenha;
    private JComboBox<String> comboCargo;

    public TelaCadastro() {
        setTitle("Cadastro");
        setSize(300, 250);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);

        JPanel painel = new JPanel();
        painel.setLayout(new GridLayout(4, 2));

        painel.add(new JLabel("CPF:"));
        txtCpf = new JTextField();
        painel.add(txtCpf);

        painel.add(new JLabel("Senha:"));
        txtSenha = new JPasswordField();
        painel.add(txtSenha);

        painel.add(new JLabel("Cargo:"));
        comboCargo = new JComboBox<>(new String[]{"Admin", "Atendente"});
        painel.add(comboCargo);

        JButton btnCadastrar = new JButton("Cadastrar");
        btnCadastrar.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                cadastrarUsuario();
            }
        });
        painel.add(btnCadastrar);

        add(painel);
    }

    private void cadastrarUsuario() {
        String cpf = txtCpf.getText();
        String senha = new String(txtSenha.getPassword());
        String cargo = (String) comboCargo.getSelectedItem();

        // Conexão com o banco de dados
        String url = "jdbc:postgresql://localhost:5432/seu_banco_de_dados"; // Altere para o seu banco de dados
        String usuario = "seu_usuario"; // Altere para o seu usuário
        String senhaBanco = "sua_senha"; // Altere para a sua senha

        try (Connection conn = DriverManager.getConnection(url, usuario, senhaBanco)) {
            String sql = "INSERT INTO tb_funcionarios (fun_cpf, fun_senha, fun_cargo) VALUES (?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, cpf);
            stmt.setString(2, senha);
            stmt.setString(3, cargo);
            stmt.executeUpdate();

            JOptionPane.showMessageDialog(this, "Usuário cadastrado com sucesso!");
            dispose(); // Fecha a tela de cadastro
        } catch (Exception ex) {
            ex.printStackTrace();
            JOptionPane.showMessageDialog(this, "Erro ao cadastrar usuário.", "Erro", JOptionPane.ERROR_MESSAGE);
        }
    }
}
